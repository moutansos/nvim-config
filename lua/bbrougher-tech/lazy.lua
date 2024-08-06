vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("bbrougher-tech.plugins.telescope"),
    require("bbrougher-tech.plugins.vscode-colors"),
    require("bbrougher-tech.plugins.treesitter"),
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/playground",
    require("bbrougher-tech.plugins.harpoon"),
    "mbbill/undotree",
    "sbdchd/neoformat",
    "ojroques/vim-oscyank",
    "ryanoasis/vim-devicons",
    "github/copilot.vim",
    "leoluz/nvim-dap-go",
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },
    require("bbrougher-tech.plugins.nvim-dap-ui"),
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "FabijanZulj/blame.nvim",
    require("bbrougher-tech.plugins.indent-blankline"),
    require("bbrougher-tech.plugins.neotest"),
    require("bbrougher-tech.plugins.null-ls"),
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    require("bbrougher-tech.plugins.lualine"),
    require("bbrougher-tech.plugins.lsp-zero"),
    "rafamadriz/friendly-snippets",
    {
        "Pocco81/auto-save.nvim",
        -- enabled = false,
        config = function()
            require("auto-save").setup({
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if vim.api.nvim_buf_is_loaded(buf) == 0 then
                        return false
                    end

                    -- don't save the harpoon menu
                    local bufName = ""
                    if pcall(function()
                            bufName = vim.api.nvim_buf_get_name(buf)
                        end) then
                        if string.match(bufName, "__harpoon.menu__") then
                            return false
                        end
                    else
                        return false
                    end

                    if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                        return true -- met condition(s), can save
                    end
                    return false -- can't save
                end,
            })
        end,
    },
    "numToStr/Comment.nvim",
    require("bbrougher-tech.plugins.luasnip"),
    require("bbrougher-tech.plugins.cloak"),
    {
        "terrortylor/nvim-comment",
        cmd = { "CommentToggle" },
        keys = {
            {
                "gcc",
                mode = { "v" },
            },
            "gc",
        },
        config = function()
            require("nvim_comment").setup({})
        end,
    },
    {
        "ThePrimeagen/vim-apm",
        keys = {
            {
                "<leader>pm",
                function()
                    require("vim-apm").toggle_monitor()
                end,
                mode = { "n" },
            },
        },
        config = function()
            local apm = require("vim-apm")

            apm:setup({})
            vim.keymap.set("n", "<leader>pm", function()
                apm:toggle_monitor()
            end)
        end,
    },
    {
        "fabridamicelli/cronex.nvim",
        opts = {},
    },
    {
        "robitx/gp.nvim",
        config = function()
            -- local default_code_system_prompt = "You are an AI working as a code editor.\n\n"
            --     .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            --     .. "START AND END YOUR ANSWER WITH:\n\n```"
            local default_chat_system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Ask question if you need clarification to provide better answer.\n"
                .. "- Think deeply and carefully from first principles step by step.\n"
                .. "- Zoom out first to see the big picture and then zoom in to details.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n"
                .. "- Take a deep breath; You've got this!\n"

            local osName = vim.loop.os_uname().sysname
            local copilotSecrets = {}
            if osName == "Windows_NT" then
                copilotSecrets = {
                    "cmd",
                    "/c",
                    "type %LOCALAPPDATA%\\github-copilot\\hosts.json | wsl sed -e 's/.*oauth_token...//;s/\".*//'",
                }
            else
                copilotSecrets = {
                    "bash",
                    "-c",
                    "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
                }
            end

            require("gp").setup({
                openapi_api_key = os.getenv("OPENAI_API_KEY"),
                providers = {
                    openai = {
                        disable = false,
                        endpoint = "https://api.openai.com/v1/chat/completions",
                        secret = os.getenv("OPENAI_API_KEY"),
                    },
                    azure = {
                        disable = false,
                        endpoint = os.getenv("AZURE_OPEN_AI_ENDPOINT"),
                        secret = os.getenv("OPENAI_API_KEY"),
                    },
                    copilot = {
                        disable = false,
                        endpoint = "https://api.githubcopilot.com/chat/completions",
                        secret = copilotSecrets,
                    },
                    ollama = {
                        disable = false,
                        endpoint = "http://msyke-desktop1.nebula:11434/v1/chat/completions",
                    },
                },
                agents = {
                    {
                        name = "ChatGPT4o",
                        chat = true,
                        command = false,
                        -- string with model name or table with model name and parameters
                        model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
                        -- system prompt (use this to specify the persona/role of the AI)
                        system_prompt = default_chat_system_prompt,
                    },
                    {
                        provider = "openai",
                        name = "ChatGPT3-5",
                        chat = true,
                        command = false,
                        -- string with model name or table with model name and parameters
                        model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
                        -- system prompt (use this to specify the persona/role of the AI)
                        system_prompt = default_chat_system_prompt,
                    },
                    {
                        provider = "copilot",
                        name = "ChatCopilot",
                        chat = true,
                        command = false,
                        -- string with model name or table with model name and parameters
                        model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
                        -- system prompt (use this to specify the persona/role of the AI)
                        system_prompt = default_chat_system_prompt,
                    },
                },
            })
        end,
        keys = {
            { "<leader>cc",  "<cmd>GpChatToggle popup<CR>", desc = "Start Chat" },
            { "<leader>cr",  "<cmd>GpChatRewrite<CR>",      desc = "Rewrite Code" },
            { "<leader>cp",  "<cmd>GpChatPaste<CR>",        desc = "Paste Code into a new chat" },
            { "<leader>can", "<cmd>GpNextAgent<CR>",        desc = "Next Agent" },
            { "<leader>cap", "<cmd>GpAgent<CR>",            desc = "Show Current Agent" },
        },
    },
})
