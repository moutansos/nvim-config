vim.keymap.set("n", "<F5>", "<cmd>lua require('dap').continue()<CR>")
vim.keymap.set("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>")
vim.keymap.set("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>")
vim.keymap.set("n", "<F12>", "<cmd>lua require('dap').step_out()<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>")
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

require('nvim-dap-virtual-text').setup({})
require('dap-go').setup()
require('dapui').setup()

local dap, dapui = require('dap'), require('dapui')
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

dap.adapters.coreclr = {
    type = 'executable',
    command = '/home/ben/.local/bin/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
  {
    name = "Launch - netcoredbg",
    type = "coreclr",
    request = "launch",
    program = function()
      local env = "Development"
      vim.env.DOTNET_ENVIRONMENT = env
      vim.env.ASPNETCORE_ENVIRONMENT = env
      return vim.fn.input('Path to built dll/exe: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
    cwd = '${fileDirname}',
  },
}

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='➡️ ', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='⛔️', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='🟠', texthl='', linehl='', numhl=''})


