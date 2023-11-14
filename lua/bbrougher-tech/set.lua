vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.loop.os_homedir() .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.g.mapleader = " "

vim.wo.relativenumber = true

-- vim.opt.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = { 
        name = 'WslClipboard',
        copy = {
            ["+"] = 'clip.exe',
            ["*"] = 'clip.exe',
        },
        paste = {
            ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", [string]::Empty))',
            ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", [string]::Empty))',
        },
        cache_enabled = 0,
   }
end

vim.keymap.set('n', '<leader>c', '<Plug>OSCYankOperator')
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', '<Plug>OSCYankVisual')

