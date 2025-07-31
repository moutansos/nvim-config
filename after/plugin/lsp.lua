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

-- vim.lsp.config["ts_ls"] = {
--     cmd = { "typescript-language-server", "--stdio" },
--     capabilities = capabilities,
--     init_options = {
--         hostInfo = "neovim",
--         plugins = {
--             {
--                 name = "@vue/typescript-plugin",
--                 location = vim.fn.stdpath("data")
--                     .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
--                 languages = { "vue" },
--             },
--         },
--     },
--     on_attach = on_attach,
--     root_pattern = { "package.json", "tsconfig.json" },
--     filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "vue" },
-- }

vim.lsp.config("lua_ls", {
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

vim.lsp.config("yamlls", {
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
    capabilities = capabilities,
})

local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local vtsls_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}

local vue_ls_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)

-- vim.lsp.enable("ts_ls")
vim.lsp.enable("csharp_ls")
vim.lsp.enable("htmx")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")

vim.lsp.enable({'vtsls', 'vue_ls'})

vim.diagnostic.config({
    virtual_text = true,
})
