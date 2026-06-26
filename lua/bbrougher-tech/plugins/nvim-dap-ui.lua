return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-telescope/telescope-dap.nvim",
        "leoluz/nvim-dap-go",
        "theHamsta/nvim-dap-virtual-text",
    },
    -- These live on the parent (nvim-dap-ui) rather than the nvim-dap dependency
    -- so that pressing any of them loads the full stack AND runs `config` below,
    -- which registers `dap.configurations.cs`. If they were on the dependency,
    -- <F5> would load nvim-dap alone and `continue()` would fire before any
    -- configurations were registered ("No configuration found for `cs`").
    keys = {
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
        },
        {
            "<F10>",
            function()
                require("dap").step_over()
            end,
        },
        {
            "<F11>",
            function()
                require("dap").step_into()
            end,
        },
        {
            "<F12>",
            function()
                require("dap").step_out()
            end,
        },
        {
            "<leader>b",
            function()
                require("dap").toggle_breakpoint()
            end,
        },
        {
            "<leader>B",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
        },
        {
            "<leader>lp",
            function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end,
        },
        {
            "<leader>dr",
            function()
                require("dap").repl.open()
            end,
        },
        {
            "<leader>dl",
            function()
                require("dap").run_last()
            end,
        },
        {
            "<leader>dx",
            function()
                require("dap").terminate()
            end,
        },
        {
            "<leader>dh",
            function()
                require("dap.ui.widgets").hover()
            end,
        },
        {
            "<leader>dp",
            function()
                require("dap.ui.widgets").preview()
            end,
        },
        {
            "<leader>df",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames)
            end,
        },
        {
            "<leader>ds",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
            end,
        },
        {
            "<leader>de",
            function()
                require("dapui").eval()
            end,
            mode = { "n", "v" },
            desc = "DAP eval (word/selection)",
        },
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        -- Initialize dap-ui (populates its element/layout registry). Without
        -- this, dapui.open() fails in enable_controls because the configured
        -- controls element resolves to nil.
        dapui.setup()

        -- On Windows nvim can produce buffer names with mixed path separators
        -- (a forward-slash cwd joined to the relative name with a backslash,
        -- e.g. "D:/source/repos/Proj\Proj/Foo.cs"). nvim-dap sends the raw
        -- buffer name as the breakpoint `source.path`, and netcoredbg can't
        -- match a mixed-separator path against the native backslash paths in
        -- the PDB -> "No symbols have been loaded for this document" and the
        -- breakpoint never binds (shows as rejected). LSP is unaffected because
        -- it converts the name to a normalized file:// URI. Normalize C# buffer
        -- names to consistent backslashes so breakpoints resolve.
        if vim.fn.has("win32") == 1 then
            local function normalizeCsBufferName(buf)
                local name = vim.api.nvim_buf_get_name(buf)
                if name == "" then
                    return
                end
                local normalized = name:gsub("/", "\\")
                if normalized ~= name then
                    vim.api.nvim_buf_set_name(buf, normalized)
                end
            end

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                group = vim.api.nvim_create_augroup("DapNormalizeCsPaths", { clear = true }),
                pattern = "*.cs",
                callback = function(args)
                    normalizeCsBufferName(args.buf)
                end,
            })

            -- Fix any C# buffers already open before this config loaded.
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_name(buf):match("%.cs$") then
                    normalizeCsBufferName(buf)
                end
            end
        end

        -- The .csproj chosen for the current launch. Memoized so the project
        -- picker only appears once even though dap evaluates `program` and `cwd`
        -- independently. Cleared when the session ends so the next launch re-picks.
        local selectedProject = nil

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
            selectedProject = nil
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
            selectedProject = nil
        end

        local masonBaseDir = vim.fn.stdpath("data") .. "/mason"
        local patchDir = vim.fn.stdpath("data") .. "/manual-dap-binaries"

        -- Recurse upwards to find the solution/project root: the first directory
        -- containing a .sln, falling back to the nearest directory with a .csproj.
        local function findDotNetRoot(startDirectory)
            local currentDirectory = startDirectory
            local csprojFallback = nil
            while currentDirectory ~= nil and currentDirectory ~= "" do
                if #vim.fn.glob(currentDirectory .. "/*.sln") > 0 then
                    return currentDirectory
                end
                if csprojFallback == nil and #vim.fn.glob(currentDirectory .. "/*.csproj") > 0 then
                    csprojFallback = currentDirectory
                end
                local parent = vim.fn.fnamemodify(currentDirectory, ":h")
                if parent == currentDirectory then
                    break
                end
                currentDirectory = parent
            end
            return csprojFallback
        end

        -- Generic single-choice Telescope picker. Yields the dap coroutine and
        -- returns the `value` of the chosen entry, or nil if dismissed.
        --
        -- NOTE: this must run inside a coroutine (every nvim-dap config option
        -- function does — see eval_option in dap.lua). It yields the dap
        -- coroutine and Telescope's select action resumes it.
        --
        -- opts: { prompt_title, results, entry_maker, default, default_selection_index }
        local function telescopeSelect(opts)
            -- If we're somehow not in a coroutine we can't block on the picker.
            local co, isMain = coroutine.running()
            if co == nil or isMain then
                return opts.default
            end

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local resumed = false
            local function finish(value)
                if resumed then
                    return
                end
                resumed = true
                coroutine.resume(co, value)
            end

            pickers
                .new({}, {
                    prompt_title = opts.prompt_title,
                    -- Keep results in the given order and select the top one by
                    -- default, so a caller-provided default sits at index 1.
                    sorting_strategy = "ascending",
                    default_selection_index = opts.default_selection_index,
                    finder = finders.new_table({
                        results = opts.results,
                        entry_maker = opts.entry_maker,
                    }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr)
                        -- Resume with nil if the picker is dismissed without a
                        -- selection (e.g. <Esc>), so dap doesn't hang forever.
                        vim.api.nvim_create_autocmd("BufWipeout", {
                            buffer = prompt_bufnr,
                            once = true,
                            callback = function()
                                finish(nil)
                            end,
                        })
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            -- Mark resumed before closing so the BufWipeout
                            -- autocmd above becomes a no-op rather than resuming
                            -- the coroutine with nil ahead of our selection.
                            if resumed then
                                return
                            end
                            resumed = true
                            actions.close(prompt_bufnr)
                            coroutine.resume(co, selection and selection.value or nil)
                        end)
                        return true
                    end,
                })
                :find()

            local value = coroutine.yield()
            if value == nil then
                return opts.default
            end
            return value
        end

        -- Find the .NET root, gather every .csproj beneath it, and return the
        -- path to the chosen project's .csproj. When several projects exist,
        -- prompt the user to pick one via Telescope.
        local function selectDotNetProject(currentFileDirectory)
            local root = findDotNetRoot(currentFileDirectory)
            if root == nil then
                return nil
            end

            local csprojFiles = vim.fn.glob(root .. "/**/*.csproj", false, true)
            if #csprojFiles == 0 then
                return nil
            end
            if #csprojFiles == 1 then
                return csprojFiles[1]
            end

            return telescopeSelect({
                prompt_title = "Select project to debug",
                results = csprojFiles,
                default = csprojFiles[1],
                entry_maker = function(entry)
                    local display = entry:sub(#root + 2)
                    return {
                        value = entry,
                        display = display,
                        ordinal = display,
                        path = entry,
                    }
                end,
            })
        end

        -- Prompt for the ASP.NET / .NET environment, defaulting to Development.
        local function selectEnvironment()
            local environments = {
                "Development",
                "KubeDevelopment",
                "KubeUat",
                "KubeProduction",
                "Production",
            }
            return telescopeSelect({
                prompt_title = "Select environment",
                results = environments,
                default = "Development",
                default_selection_index = 1,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry,
                        ordinal = entry,
                    }
                end,
            })
        end

        -- Pick the project once per launch and reuse it for the rest of the
        -- config (program + cwd) so the Telescope picker only shows up once.
        local function getSelectedProject()
            if selectedProject == nil then
                selectedProject = selectDotNetProject(vim.fn.expand("%:p:h"))
            end
            return selectedProject
        end

        -- Directory containing the chosen .csproj (used as the debug cwd).
        local function getDotNetWorkingDirectory()
            local csproj = getSelectedProject()
            if csproj ~= nil then
                return vim.fn.fnamemodify(csproj, ":h")
            end
            return nil
        end

        -- Resolve the built dll for a given .csproj by globbing its bin output.
        -- Prefers a Debug build, then the most recently built artifact. Returns
        -- nil if nothing has been built yet.
        local function getDotNetProgramPath(csproj)
            local projectDir = vim.fn.fnamemodify(csproj, ":h")

            -- Assembly name defaults to the project file name, but respect an
            -- explicit <AssemblyName> if the project declares one.
            local assemblyName = vim.fn.fnamemodify(csproj, ":t:r")
            local ok, lines = pcall(vim.fn.readfile, csproj)
            if ok then
                local content = table.concat(lines, "\n")
                local explicit = content:match("<AssemblyName>%s*(.-)%s*</AssemblyName>")
                if explicit and explicit ~= "" then
                    assemblyName = explicit
                end
            end

            local matches = vim.fn.glob(projectDir .. "/bin/**/" .. assemblyName .. ".dll", false, true)

            -- Drop copies that aren't the real runnable assembly: reference
            -- assemblies (bin/.../ref|refint/) have no IL/debug info, and
            -- publish folders are a separate output we don't want to debug.
            local dlls = {}
            for _, dll in ipairs(matches) do
                local lower = dll:lower()
                if
                    not lower:find("[/\\]ref[/\\]")
                    and not lower:find("[/\\]refint[/\\]")
                    and not lower:find("[/\\]publish[/\\]")
                then
                    table.insert(dlls, dll)
                end
            end

            if #dlls == 0 then
                return nil
            end

            table.sort(dlls, function(a, b)
                local aDebug = a:lower():find("[/\\]debug[/\\]") ~= nil
                local bDebug = b:lower():find("[/\\]debug[/\\]") ~= nil
                if aDebug ~= bDebug then
                    return aDebug
                end
                return vim.fn.getftime(a) > vim.fn.getftime(b)
            end)

            return dlls[1]
        end

        -- Build the given project before launch so we never debug a stale dll
        -- (nvim-dap does not honor `preLaunchTask`). Runs asynchronously and
        -- yields the dap coroutine until `dotnet build` finishes. Returns
        -- (ok, output_lines).
        --
        -- Must run inside a coroutine (the dap config option functions do).
        local function buildDotNetProject(csproj)
            local co, isMain = coroutine.running()
            if co == nil or isMain then
                -- No coroutine to block on; skip building rather than freeze.
                return true, {}
            end

            vim.notify(
                "Building " .. vim.fn.fnamemodify(csproj, ":t") .. " ...",
                vim.log.levels.INFO,
                { title = "netcoredbg" }
            )

            local Job = require("plenary.job")
            Job:new({
                command = "dotnet",
                args = { "build", csproj, "-c", "Debug", "--nologo" },
                on_exit = function(j, code)
                    -- Resume back on the main loop; on_exit runs in a luv thread.
                    vim.schedule(function()
                        coroutine.resume(co, code, j:result())
                    end)
                end,
            }):start()

            local code, output = coroutine.yield()
            return code == 0, output or {}
        end

        function sleep(s)
            local ntime = os.time() + s
            repeat
            until os.time() > ntime
        end

        function tprint(tbl, indent)
            if not indent then
                indent = 0
            end
            local toprint = string.rep(" ", indent) .. "{\r\n"
            indent = indent + 2
            for k, v in pairs(tbl) do
                toprint = toprint .. string.rep(" ", indent)
                if type(k) == "number" then
                    toprint = toprint .. "[" .. k .. "] = "
                elseif type(k) == "string" then
                    toprint = toprint .. k .. "= "
                end
                if type(v) == "number" then
                    toprint = toprint .. v .. ",\r\n"
                elseif type(v) == "string" then
                    toprint = toprint .. '"' .. v .. '",\r\n'
                elseif type(v) == "table" then
                    toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
                else
                    toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
                end
            end
            toprint = toprint .. string.rep(" ", indent - 2) .. "}"
            return toprint
        end

        dap.adapters.coreclr = {
            type = "executable",
            command = masonBaseDir .. "/packages/netcoredbg/netcoredbg/netcoredbg",
            -- command = patchDir .. '/netcoredbg/netcoredbg',
            args = { "--interpreter=vscode" },
        }

        dap.adapters.netcoredbg = dap.adapters.coreclr

        dap.configurations.cs = {
            {
                name = "Launch - netcoredbg (dev)",
                type = "coreclr",
                request = "launch",
                preLaunchTask = "build",
                program = function()
                    local env = selectEnvironment()
                    vim.env.DOTNET_ENVIRONMENT = env
                    vim.env.ASPNETCORE_ENVIRONMENT = env

                    local csproj = getSelectedProject()
                    if csproj ~= nil then
                        -- Always build first so breakpoints bind to fresh symbols.
                        local ok, output = buildDotNetProject(csproj)
                        if not ok then
                            vim.notify(
                                "Build failed — aborting launch.\n" .. table.concat(output, "\n"),
                                vim.log.levels.ERROR,
                                { title = "netcoredbg" }
                            )
                            return dap.ABORT
                        end

                        local dll = getDotNetProgramPath(csproj)
                        if dll ~= nil then
                            vim.notify(
                                "DAP launch\n  env: " .. env .. "\n  program: " .. dll,
                                vim.log.levels.INFO,
                                { title = "netcoredbg" }
                            )
                            return dll
                        end
                    end

                    -- Couldn't resolve a built dll (no project selected, or the
                    -- build produced nothing where we expected). Fall back to
                    -- asking, defaulting to the project directory when we have one.
                    local default = csproj and (vim.fn.fnamemodify(csproj, ":h") .. "/") or vim.fn.getcwd()
                    return vim.fn.input("Path to built dll/exe: ", default, "file")
                end,
                -- cwd = '${fileDirname}',
                cwd = function()
                    local workingDirectory = getDotNetWorkingDirectory()
                    if workingDirectory ~= nil then
                        return workingDirectory
                    end
                    return vim.fn.getcwd()
                end,
                justMyCode = false,
            },
            {
                name = "Test - netcoredbg",
                type = "coreclr",
                request = "attach",
                env = {
                    VSTEST_HOST_DEBUG = "1",
                },
                processId = function()
                    local a = require("plenary.async")
                    local Job = require("plenary.job")

                    vim.env.VSTEST_HOST_DEBUG = "1"
                    local output = ""
                    local foundPid = false
                    local tx, rx = a.control.channel.oneshot()

                    local workingDirectory = getDotNetWorkingDirectory()
                    print("Working Directory: " .. (workingDirectory or "<none>"))

                    Job:new({
                        command = "dotnet",
                        args = { "test", "--no-build", "--no-restore", "--list-tests" },
                        env = {
                            ["VSTEST_HOST_DEBUG"] = "1",
                        },
                        -- cwd = workingDirectory,
                        on_stdout = function(j, data)
                            print(data)
                            output = output .. data
                            if (not foundPid) and string.find(output, "Process Id:") then
                                foundPid = true
                                print("Found test run for:")
                                local pidCapture = string.match(output, "Process Id: (%d+)")
                                print(pidCapture)
                                tx(pidCapture)
                            end
                        end,
                        on_stderr = function(_, data, _)
                            print(data)
                        end,
                        on_exit = function(j, data, _)
                            print("dotnet test exited with code " .. data)
                            for i, bufChunk in pairs(j:result()) do
                                print(bufChunk)
                            end
                            if not foundPid then
                                print("Failed to find test run")
                                tx(nil)
                            end
                        end,
                    }):start()

                    local pid = rx()
                    print("PID: " .. pid)
                    return tonumber(pid)

                    -- return tonumber(vim.fn.input('Test Process Id: '))
                end,
            },
            {
                name = "Attach - netcoredbg (pid)",
                type = "coreclr",
                request = "attach",
                processId = function()
                    return tonumber(vim.fn.input("Test Process Id: "))
                end,
            },
        }

        vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "⛔️", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texthl = "", linehl = "", numhl = "" })
    end,
}
