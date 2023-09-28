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

vim.keymap.set("n", "<leader>tm", function()
    nt.run.run()
end)

vim.keymap.set("n", "<leader>tf", function()
    nt.run.run(vim.fn.expand("%"))
end)

vim.keymap.set("n", "<leader>td", function()
    nt.run.run({ strategy = "dap" })
end)

vim.keymap.set("n", "<leader>tst", function()
    nt.run.stop()
end)

vim.keymap.set("n", "<leader>tsw", function()
    nt.summary.toggle()
end)
