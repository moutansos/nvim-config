return {
    -- dir = "~/source/repos/stashdown.nvim",
    -- name = "stashdown",
    "msyke/stashdown.nvim",
    config = function()
        local sd = require("stashdown")
        sd.setup()
    end,
    keys = {
        {
            "<leader>sdn",
            "<cmd>:Stashdown nf<CR>",
            mode = { "n" },
            desc = "Create a new stashdown markdonw file",
        },
        {
            "<leader>sde",
            "<cmd>:Stashdown ne<CR>",
            mode = { "n" },
            desc = "Create a new entry in the current markdown file",
        },
        {
            "<leader>sda",
            "<cmd>:Stashdown a<CR>",
            mode = { "n" },
            desc = "Archive the current file and all associated images",
        },
        {
            "<leader>sdi",
            "<cmd>:Stashdown ii<CR>",
            mode = { "n" },
            desc = "Insert an image into the current note file. Move the image into a folder associated with this note.",
        },
    },
    ft = { "markdown" },
}
