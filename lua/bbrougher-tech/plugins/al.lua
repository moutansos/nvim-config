return {
    "abonckus/al.nvim",
    enabled = vim.fn.has("win32") == 1,
    ft = "al",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
    opts = {},
}
