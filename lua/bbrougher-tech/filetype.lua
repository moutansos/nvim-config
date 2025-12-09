vim.filetype.add({
    extension = {
        mdx = "mdx",
    },
})

vim.filetype.add({
    extension = {
        http = "http",
    }
})

vim.treesitter.language.register("markdown", "mdx")

vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
})

vim.filetype.add({
    extension = {
        handlebars = "glimmer",
    },
})

vim.filetype.add({
    extension = {
        cs = "cs",
        csx = "csx",
    },
})
