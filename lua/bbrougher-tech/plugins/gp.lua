return {
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
                {
                    provider = "ollama",
                    name = "llama3.1",
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = { model = "llama3.1", temperature = 1.1, top_p = 1 },
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = default_chat_system_prompt,
                },
            },
        })
    end,
    keys = {
        {
            "<C-g>c",
            "<cmd>GpChatNew popup<cr>",
            mode = { "n", "i" },
            desc = "Gp.nvim New Chat",
        },
        {
            "<C-g>t",
            "<cmd>GpChatToggle popup<cr>",
            mode = { "n", "i" },
            desc = "Gp.nvim Toggle Chat",
        },
        { "<C-g>f",     "<cmd>GpChatFinder<cr>",     mode = { "n", "i" }, desc = "Chat Finder" },
        {
            "<C-g>c",
            ":<C-u>'<,'>GpChatNew popup<cr>",
            mode = "v",
            desc = "Visual Chat New",
        },
        {
            "<C-g>p",
            ":<C-u>'<,'>GpChatPaste popup<cr>",
            mode = "v",
            desc = "Visual Chat Paste",
        },
        {
            "<C-g>t",
            ":<C-u>'<,'>GpChatToggle popup<cr>",
            mode = "v",
            desc = "Visual Toggle Chat",
        },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",  mode = { "n", "i" }, desc = "New Chat split" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", mode = { "n", "i" }, desc = "New Chat vsplit" },
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", mode = { "n", "i" }, desc = "New Chat tabnew" },
        {
            "<C-g><C-x>",
            ":<C-u>'<,'>GpChatNew split<cr>",
            mode = "v",
            desc = "Visual Chat New split",
        },
        {
            "<C-g><C-v>",
            ":<C-u>'<,'>GpChatNew vsplit<cr>",
            mode = "v",
            desc = "Visual Chat New vsplit",
        },
        {
            "<C-g><C-t>",
            ":<C-u>'<,'>GpChatNew tabnew<cr>",
            mode = "v",
            desc = "Visual Chat New tabnew",
        },
        { "<C-g>r", "<cmd>GpRewrite<cr>",       mode = { "n", "i" }, desc = "Inline Rewrite" },
        { "<C-g>a", "<cmd>GpAppend<cr>",        mode = { "n", "i" }, desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>",       mode = { "n", "i" }, desc = "Prepend (before)" },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", mode = "v",          desc = "Visual Rewrite" },
        {
            "<C-g>a",
            ":<C-u>'<,'>GpAppend<cr>",
            mode = "v",
            desc = "Visual Append (after)",
        },
        {
            "<C-g>b",
            ":<C-u>'<,'>GpPrepend<cr>",
            mode = "v",
            desc = "Visual Prepend (before)",
        },
        {
            "<C-g>i",
            ":<C-u>'<,'>GpImplement<cr>",
            mode = "v",
            desc = "Implement selection",
        },
        { "<C-g>gp", "<cmd>GpPopup<cr>",        mode = { "n", "i" }, desc = "Popup" },
        { "<C-g>ge", "<cmd>GpEnew<cr>",         mode = { "n", "i" }, desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>",          mode = { "n", "i" }, desc = "GpNew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>",         mode = { "n", "i" }, desc = "GpVnew" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>",       mode = { "n", "i" }, desc = "GpTabnew" },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>",  mode = "v",          desc = "Visual Popup" },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>",   mode = "v",          desc = "Visual GpEnew" },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>",    mode = "v",          desc = "Visual GpNew" },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>",   mode = "v",          desc = "Visual GpVnew" },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", mode = "v",          desc = "Visual GpTabnew" },
        { "<C-g>x",  "<cmd>GpContext<cr>",      mode = { "n", "i" }, desc = "Toggle Context" },
        {
            "<C-g>x",
            ":<C-u>'<,'>GpContext<cr>",
            mode = "v",
            desc = "Visual Toggle Context",
        },
        { "<C-g>s",  "<cmd>GpStop<cr>",          mode = { "n", "i", "v", "x" }, desc = "Stop" },
        { "<C-g>n",  "<cmd>GpNextAgent<cr>",     mode = { "n", "i", "v", "x" }, desc = "Next Agent" },
        { "<C-g>ww", "<cmd>GpWhisper<cr>",       mode = { "n", "i" },           desc = "Whisper" },
        { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", mode = "v",                    desc = "Visual Whisper" },
        {
            "<C-g>wr",
            "<cmd>GpWhisperRewrite<cr>",
            mode = { "n", "i" },
            desc = "Whisper Inline Rewrite",
        },
        {
            "<C-g>wa",
            "<cmd>GpWhisperAppend<cr>",
            mode = { "n", "i" },
            desc = "Whisper Append (after)",
        },
        {
            "<C-g>wb",
            "<cmd>GpWhisperPrepend<cr>",
            mode = { "n", "i" },
            desc = "Whisper Prepend (before)",
        },
        {
            "<C-g>wr",
            ":<C-u>'<,'>GpWhisperRewrite<cr>",
            mode = "v",
            desc = "Visual Whisper Rewrite",
        },
        {
            "<C-g>wa",
            ":<C-u>'<,'>GpWhisperAppend<cr>",
            mode = "v",
            desc = "Visual Whisper Append (after)",
        },
        {
            "<C-g>wb",
            ":<C-u>'<,'>GpWhisperPrepend<cr>",
            mode = "v",
            desc = "Visual Whisper Prepend (before)",
        },
        { "<C-g>wp", "<cmd>GpWhisperPopup<cr>",  mode = { "n", "i" }, desc = "Whisper Popup" },
        { "<C-g>we", "<cmd>GpWhisperEnew<cr>",   mode = { "n", "i" }, desc = "Whisper Enew" },
        { "<C-g>wn", "<cmd>GpWhisperNew<cr>",    mode = { "n", "i" }, desc = "Whisper New" },
        { "<C-g>wv", "<cmd>GpWhisperVnew<cr>",   mode = { "n", "i" }, desc = "Whisper Vnew" },
        { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", mode = { "n", "i" }, desc = "Whisper Tabnew" },
        {
            "<C-g>wp",
            ":<C-u>'<,'>GpWhisperPopup<cr>",
            mode = "v",
            desc = "Visual Whisper Popup",
        },
        {
            "<C-g>we",
            ":<C-u>'<,'>GpWhisperEnew<cr>",
            mode = "v",
            desc = "Visual Whisper Enew",
        },
        { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", mode = "v", desc = "Visual Whisper New" },
        {
            "<C-g>wv",
            ":<C-u>'<,'>GpWhisperVnew<cr>",
            mode = "v",
            desc = "Visual Whisper Vnew",
        },
        {
            "<C-g>wt",
            ":<C-u>'<,'>GpWhisperTabnew<cr>",
            mode = "v",
            desc = "Visual Whisper Tabnew",
        },
    },
}
