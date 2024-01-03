local telescopeConfig = {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
	{ 
	    "<leader>pf",
	    function()
		require("telescope.builtin").find_files()
	    end,
	},
	{
		"<C-p>",
		function()
			require("telescope.builtin").git_files()
		end,
		mode = { "n", "i" },
	},
	{
		"<leader>ps",
		function()
			require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
		end,
	},
	{
		"<leader>pg",
		function()
			require("telescope.builtin").live_grep()
		end,
	}
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                },
            },
        })
    end,
}

return telescopeConfig
