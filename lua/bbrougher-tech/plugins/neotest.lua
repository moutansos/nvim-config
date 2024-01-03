return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "Issafalcon/neotest-dotnet",
    },
    keys = {
        { "<leader>tm", function() require("neotest").run.run() end },
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end },
        { "<leader>td", function() require("neotest").run.run({ strategey = "dap" }) end },
        { "<leader>tst", function() require("neotest").run.stop() end },
        { "<leader>tsw", function() require("neotest").summary.toggle() end },
    },
    config = function()
        local nt = require("neotest")
        nt.setup({
          adapters = {
            require("neotest-dotnet")({
              dap = { justMyCode = false },
            }),
            -- require("neotest-plenary"),
            -- require("neotest-vim-test")({
            --   ignore_file_types = { "python", "vim", "lua" },
            -- }),
          },
        })
    end,
}
