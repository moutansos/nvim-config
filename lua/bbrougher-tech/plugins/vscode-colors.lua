local old = {
    "Mofiqul/vscode.nvim",
    lazy = false,
    config = function()
        vim.o.background = "dark"
        local c = require("vscode.colors").get_colors()
        require("vscode").setup({
            -- Alternatively set style in setup
            -- style = 'light'

            -- Enable transparent background
            -- transparent = true,

            -- Enable italic comment
            italic_comments = true,

            -- disable_nvimtree_bg = true,

            -- Override colors (see ./lua/vscode/colors.lua)
            color_overrides = {
                vscLineNumber = "#FFFFFF",
            },

            -- Override highlight groups (see ./lua/vscode/theme.lua)
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
            },
        })
        require("vscode").load()
        vim.cmd([[highlight Normal guibg=NONE]])
        vim.cmd([[highlight NonText guibg=NONE]])
        vim.cmd([[highlight Normal ctermbg=NONE]])
        vim.cmd([[highlight NonText ctermbg=NONE]])
    end,
}

local new = {
    "askfiy/visual_studio_code",
    config = function()

        -- require("visual_studio_code").setup({
        --     mode = "dark",
        --     preset = true,
        --     transparent = false,
        -- })
        vim.cmd([[colorscheme visual_studio_code]])

        vim.cmd([[highlight Normal guibg=NONE]])
        vim.cmd([[highlight NonText guibg=NONE]])
        vim.cmd([[highlight Normal ctermbg=NONE]])
        vim.cmd([[highlight NonText ctermbg=NONE]])
    end,
    opts = {
        mode = "dark",
        preset = true,
        transparent = false,
    },
}

return old
