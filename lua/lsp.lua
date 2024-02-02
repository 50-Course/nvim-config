local M = {}

local servers = {
    "clangd", -- C/C++
    "pyright", -- Python
    "rust_analyzer", -- Rust
    "tsserver", -- TypeScript/JavaScript
    "gopls", -- Go
    "lua_ls", -- Lua
}

local on_attach = function(client, buffnr)
    local map = vim.keymap.set
    local opts = { buffer = buffnr, noremap = true, silent = true }

    -- Mappings
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    map(
        { "n", "v" },
        "<leader>f",
        "<cmd> lua vim.lsp.buf.formatting()<CR>",
        opts
    )
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    map(
        "n",
        "<leader>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        opts
    )
    map(
        "n",
        "<leader>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        opts
    )
    map(
        "n",
        "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
    )

    -- Diagonistic Keymaps
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
end

local cmp = require("cmp")
local capabalities = vim.lsp.protocol.make_client_capabilities()

capabalities = require("cmp_nvim_lsp").default_capabilities(capabalities)
require("luasnip.loaders.from_vscode").lazy_load()

local mason = require("mason")
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local source_names = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
}

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "buffer" },
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = source_names[entry.source.name]
            return vim_item
        end,
    },
})

mason.setup()
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})
mason_lspconfig.setup_handlers({
    -- Automatically configure servers installed via `:MasonInstall or :Mason `
    function(server_name)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabalities,
        })
    end,

    ["lua_ls"] = function()
        local settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                telemetry = {
                    enable = false,
                },
            },
        }
        local opts = {
            on_attach = on_attach,
            capabilities = capabalities,
            settings = settings,
        }
        lspconfig["lua_ls"].setup(opts)
    end,
    ["gopls"] = function()
        local opts = {
            on_attach = on_attach,
            capabilities = capabalities,
            cmd = { "gopls" },
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        }
        lspconfig["gopls"].setup(opts)
    end,
})

return M
