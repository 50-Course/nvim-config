local servers = {
    "pyright",       -- Python
    "rust_analyzer", -- Rust
    "ts_ls",         -- TypeScript/JavaScript
    "gopls",         -- Go
    "lua_ls",        -- Lua
}

-- Diagonistics signs
--

local on_attach = function(client, bufnr)
    local map = vim.keymap.set
    local opts = { buffer = bufnr, noremap = true, silent = true }

    local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, text_icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = text_icon, texthl = hl, numhl = "" })
    end

    -- Mappings
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<C-k>",
        "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
        { noremap = true, silent = true }
    )
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "<leader>vws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    map("n", "<leader>rr", function()
        vim.lsp.buf.references()
    end, opts)
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
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
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next)
    -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
end

local cmp = require("cmp")
local capabalities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("cmp_nvim_lsp").default_capabilities(capabalities)
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local mason = require("mason")
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local source_names = {
    nvim_lsp = "[LSP]",
    nvim_lsp_signature_help = "[Signature]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,popup,noinsert,fuzzy",
    },
    mapping = cmp.mapping.preset.insert({
        -- Manually trigger snippet completion from nvim-cmp
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,
        -- Navigate through the completion list
        --
        -- <C-n> and <C-p> are used to navigate through the completion list [f]orward and [b]ackward.
        -- However, these keys are also used to navigate the quickfix list.
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        -- Navigate through the snippet list
        -- using the same keys as the completion list
        ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable() then
                luasnip.expand_or_jump(-1)
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp",               keyword_length = 3 }, -- LSP
        { name = "nvim_lsp_signature_help" },      -- display function signature with current param emphasized
        { name = "nvim_lua",               keyword_length = 2 }, -- lua runtime API
        { name = "luasnip" },                      -- nvim-cmp for snippets
        { name = "buffer",                 keyword_length = 2 }, -- completion from current buffer
        { name = "path" },                         -- file paths
    }),
    formatting = {
        fields = { "menu", "abbr", "kind" },
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
            capabilities = capabilities,
        })
    end,

    ["lua_ls"] = function()
        local settings = {
            runtime = {
                version = "LuaJIT",
            },
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
            capabilities = capabilities,
            on_attach = on_attach,
            settings = settings,
        }
        lspconfig["lua_ls"].setup(opts)
    end,
    ["gopls"] = function()
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
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
    ["ruff"] = function()
        local opts = {
            cmd = {
                "ruff",
                "server",
            },
            on_attach = on_attach,
            capabilities = capabilities,
        }
        lspconfig["ruff"].setup(opts)
    end,
    ["mdx_analyzer"] = function()
        local opts = {
            capabilities = capabilities,
            filetypes = { "markdown.mdx", "mdx" },
        }
        lspconfig["mdx_analyzer"].setup(opts)
    end,
    -- ["elixir-ls"] = function()
    --     local opts = {
    --         capabilities = capabilities,
    --         cmd = { "elixir-ls" },
    --         on_attach = on_attach,
    --         settings = {
    --             elixirLS = {
    --                 dialyzerEnabled = true,
    --                 fetchDeps = true,
    --                 enableTestLenses = true,
    --                 suggestSpecs = true,
    --             },
    --         },
    --     }
    --     lspconfig["elixir-ls"].setup(opts)
    -- end,
})

-- require("spring_boot").init_lsp_commands()
-- require("lspconfig").jdtls.setup({
--     init_options = {
--         bundles = require("spring_boot").java_extensions(),
--     },
-- })

-- vim.diagnostic.config({
--     virtual_text = true,
--     update_on_insert = true,
-- })
