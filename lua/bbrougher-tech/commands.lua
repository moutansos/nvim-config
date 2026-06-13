function startsWith(text, prefix)
	return text:find(prefix, 1, true) == 1
end

vim.api.nvim_create_user_command("GG", function(opts)
	git_cmd = opts.fargs[1]
	cwd = vim.loop.cwd()
	if vim.fn.has("wsl") == 1 and startsWith(cwd, "/mnt/") then
		vim.cmd("split term://git.exe " .. git_cmd)
	else
		vim.cmd("split term://git " .. git_cmd)
	end
end, { nargs = 1 })

-- Start tree-sitter highlighting for all file types, but wrap in pcall to avoid errors if a parser isn't installed
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("EnableTreesitterHighlighting", { clear = true }),
	desc = "Enable tree-sitter syntax highlighting",
	pattern = "*",
	callback = function()
		-- Wrap in pcall to avoid errors if a parser isn't installed
		pcall(vim.treesitter.start)
	end,
})
