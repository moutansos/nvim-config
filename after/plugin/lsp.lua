local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "<leader>gdd", function()
        vim.cmd(":belowright split")
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>vws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>vca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<C-.>", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vrr", function()
        vim.lsp.buf.references()
    end, opts)
    vim.keymap.set("n", "<leader>vrn", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)
end

-- lspconfig.denols.setup {
--   root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
-- }

vim.lsp.config['ts_ls'] = {
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities,
    init_options = {
        hostInfo = "neovim",
    },
    on_attach = on_attach,
    root_pattern = { "package.json", "tsconfig.json" },
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
}



-- lspconfig.csharp_ls.setup({
--     root_dir = function(startpath)
--         return lspconfig.util.root_pattern("*.sln")(startpath)
--             or lspconfig.util.root_pattern("*.csproj")(startpath)
--             or lspconfig.util.root_pattern(".git")(startpath)
--     end,
--     -- handlers = {
--     --     ["textDocument/definition"] = require('csharpls_extended').handler,
--     --     ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
--     -- },
-- })

vim.lsp.config('lua_ls', {
    cmd = { "lua-language-server" },
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        hostInfo = "neovim",
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    filetypes = { "lua" },
})

vim.lsp.config('yamlls', {
    cmd = { "yaml-language-server", "--stdio" },
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        yaml = {
            schemas = {
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                    "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                    "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                    "*flow*.{yml,yaml}",
            },
        },
    },
})

vim.lsp.config("gopls", {
    on_attach = on_attach,
})

Vim.lsp.enable('ts_ls')
vim.lsp.enable('csharp_ls')
vim.lsp.enable('htmx')
vim.lsp.enable('jsonls')
vim.lsp.enable('yamlls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')

vim.diagnostic.config({
    virtual_text = true,
})
