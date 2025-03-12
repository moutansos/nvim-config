vim.g.mapleader = " "

local lsp = require("lsp-zero")

lsp.preset("recommended")

local ensureInstalled = {
    "rust_analyzer",
    "yamlls",
    "jsonls",
}

-- lsp.ensure_installed(ensureInstalled) -- Deprecated since 2.x
require("mason-lspconfig").setup({
    ensure_installed = ensureInstalled,
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
        end,
    },
})

require("mason-lspconfig").setup_handlers({
    -- Will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        -- https://github.com/neovim/nvim-lspconfig/pull/3232
        if server_name == "tsserver" then
            server_name = "ts_ls"
        end
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
        })
    end,
})

-- Fix Undefined global 'vim'
-- lsp.nvim_workspace() -- Deprecated since 2.x

local cmp = require("cmp")
local cmp_format = require("lsp-zero").cmp_format()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings,
-- })

cmp.setup({
    mapping = cmp_mappings,
    formatting = cmp_format,
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "?",
        warn = "?",
        hint = "H",
        info = "?",
    },
})

lsp.on_attach(function(client, bufnr)
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
end)

local lspconfig = require("lspconfig")

lspconfig.snyk_ls.setup {
    root_dir = lspconfig.util.root_pattern('.git'),
    filetypes = { "go", "gomod","csharp", "javascript", "typescript", "json", "python", "requirements", "helm", "yaml", "terraform", "terraform-vars" },
    init_options = {
        activateSnykCode = "true"
    },
    single_file_support = true,
}

lspconfig.denols.setup {
  -- on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.ts_ls.setup {
  -- on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
}

lspconfig.csharp_ls.setup({
    root_dir = function(startpath)
        return lspconfig.util.root_pattern("*.sln")(startpath)
            or lspconfig.util.root_pattern("*.csproj")(startpath)
            or lspconfig.util.root_pattern(".git")(startpath)
    end,
    -- handlers = {
    --     ["textDocument/definition"] = require('csharpls_extended').handler,
    --     ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
    -- },
})

lspconfig.htmx.setup({
    filetypes = { "html" },
})

lspconfig.yamlls.setup({
    settings = {
        yaml = {
            schemas = {
                kubernetes = "kube.*.{yaml,yml}",
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

lspconfig.jsonls.setup({})

lspconfig.mojo.setup({
    cmd = { "mojo-lsp-server" },
    filetypes = { "mojo" },
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
