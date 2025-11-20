return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        {
            "mfussenegger/nvim-dap",
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
            },
        },
        "nvim-telescope/telescope-dap.nvim",
        "leoluz/nvim-dap-go",
        "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
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
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        local masonBaseDir = vim.fn.stdpath("data") .. "/mason"
        local patchDir = vim.fn.stdpath("data") .. "/manual-dap-binaries"

        -- Recurse upwards until you find the csproj file in the current directory
        -- then return that directory
        local function getDotNetWorkingDirectory(currentFileDirectory)
            local currentDirectory = currentFileDirectory
            while currentDirectory ~= nil do
                local csprojFiles = vim.fn.glob(currentDirectory .. "/*.csproj")
                if #csprojFiles > 0 then
                    return currentDirectory
                end
                currentDirectory = vim.fn.fnamemodify(currentDirectory, ":h")
            end
            return nil
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
                    local env = "Development"
                    vim.env.DOTNET_ENVIRONMENT = env
                    vim.env.ASPNETCORE_ENVIRONMENT = env
                    return vim.fn.input("Path to built dll/exe: ", vim.fn.getcwd(), "file")
                end,
                -- cwd = '${fileDirname}',
                cwd = function()
                    local currentFileDirectory = vim.fn.expand("%:p:h")
                    local workingDirectory = getDotNetWorkingDirectory(currentFileDirectory)
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

                    local currentFileDirectory = vim.fn.expand("%:p:h")
                    local workingDirectory = getDotNetWorkingDirectory(currentFileDirectory)
                    print("Working Directory: " .. workingDirectory)

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
        vim.fn.sign_define("DapStopped", { text = "➡️ ", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "⛔️", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texthl = "", linehl = "", numhl = "" })
    end,
}
