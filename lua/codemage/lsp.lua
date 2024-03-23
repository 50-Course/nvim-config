local servers = {
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
    map("n", "<leader>vws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    map("n", "<leader>vrr", function()
        vim.lsp.buf.references()
    end, opts)
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
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
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
end

local cmp = require("cmp")
local capabalities = vim.lsp.protocol.make_client_capabilities()

capabalities = require("cmp_nvim_lsp").default_capabilities(capabalities)
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
        completeopt = "menuone,noselect,noinsert",
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
        { name = "nvim_lsp", keyword_length = 3 }, -- LSP
        { name = "nvim_lsp_signature_help" }, -- display function signature with current param emphasized
        { name = "nvim_lua", keyword_length = 2 }, -- lua runtime API
        { name = "luasnip" }, -- nvim-cmp for snippets
        { name = "buffer", keyword_length = 2 }, -- completion from current buffer
        { name = "path" }, -- file paths
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
            capabilities = capabalities,
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
            capabilities = capabalities,
            on_attach = on_attach,
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

vim.diagnostic.config({
    virtual_text = true,
    update_on_insert = true,
})
