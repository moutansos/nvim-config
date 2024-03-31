return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-neotest/nvim-nio" },
    keys = {
        { "<space>rr",  "<cmd>Rest run<cr>" },
    },
    lazy = false,
    config = function()
        require("rest-nvim").setup({
            client = "curl",
            -- Skip SSL verification, useful for unknown certificates
            skip_ssl_verification = false,
            -- Encode URL before making request
            encode_url = true,
            -- Highlight request on run
            highlight = {
                enable = true,
                timeout = 150,
            },
            result = {
                split = {
                    horizontal = false,
                    in_place = false,
                    stay_in_current_window_after_split = false,
                },
                behavior = {
                    -- set them to false if you want to disable them
                    formatters = {
                        json = "jq",
                        html = function(body)
                            if vim.fn.executable("tidy") == 0 then
                                return body, { found = false, name = "tidy" }
                            end
                            local fmt_body = vim.fn.system({
                                "tidy",
                                "-i",
                                "-q",
                                "--tidy-mark", "no",
                                "--show-body-only", "auto",
                                "--show-errors", "0",
                                "--show-warnings", "0",
                                "-",
                            }, body):gsub("\n$", "")

                            return fmt_body, { found = true, name = "tidy" }
                        end,
                    },
                },
            },
            env_file = ".env",
            custom_dynamic_variables = {},
        })
    end,
}
