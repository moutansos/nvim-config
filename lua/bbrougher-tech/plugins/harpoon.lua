return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    lazy = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
    },
    opts = {
        settings = {
            save_on_toggle = true,
            save_on_ui_close = true,
        },
        default = {},
    },
    keys = function()
        local harpoon = require("harpoon")
        return {
            { "<leader>a", function() harpoon:list():add() end, desc = "Add file to Harpoon" },
            { "<C-q>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Toggle Harpoon Menu" },
            { "<leader>1", function() harpoon:list():select(1) end, desc = "Go to Harpoon 1" },
            { "<leader>2", function() harpoon:list():select(2) end, desc = "Go to Harpoon 2" },
            { "<leader>3", function() harpoon:list():select(3) end, desc = "Go to Harpoon 3" },
            { "<leader>4", function() harpoon:list():select(4) end, desc = "Go to Harpoon 4" },
            { "<leader>5", function() harpoon:list():select(5) end, desc = "Go to Harpoon 5" },
            { "<leader>6", function() harpoon:list():select(6) end, desc = "Go to Harpoon 6" },
            { "<leader>7", function() harpoon:list():select(7) end, desc = "Go to Harpoon 7" },
            { "<leader>8", function() harpoon:list():select(8) end, desc = "Go to Harpoon 8" },
            { "<leader>9", function() harpoon:list():select(9) end, desc = "Go to Harpoon 9" },
            { "<leader>0", function() harpoon:list():select(10) end, desc = "Go to Harpoon 10" },
        }
    end,
}
