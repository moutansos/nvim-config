return {
    "nvim-lualine/lualine.nvim",
    dependson = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('lualine').setup {
            options = {
                theme = 'powerline'
            }
        }
    end,
}
