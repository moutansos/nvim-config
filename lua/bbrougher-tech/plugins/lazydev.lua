--@type LazySpec
return {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
        library = {
            -- Match files in your plugins directory
            { path = "lazy.nvim",         words = { "lazy.nvim", "lazy", "LazyPluginSpec", "LazySpec" } },
            -- Make it available in all lua files in plugins/
            { path = "${3rd}/luv/library" },
        },
    },
}
