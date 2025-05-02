return {
    "terrortylor/nvim-comment",
    cmd = { "CommentToggle" },
    keys = {
        {
            "gcc",
            mode = { "v" },
        },
        "gc",
    },
    config = function()
        require("nvim_comment").setup({})
    end,
}
