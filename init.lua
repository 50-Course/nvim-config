------------------------------------------
--- PERSONAL DEVELOPMENT ENVIRONMENT
---
--- 2024 is the year of efficiency and winnings - I can feel it! - Jan 7, 24
--- Author: Eri (@50Course/@codemage)
--- License: MIT License
------------------------------------------

-- ******************************** SPEED UP LOAD TIME ********************************
vim.loader.enable()

--- Disable VIM defaults
-- Nobody likes the top banner on NetRW -- I don't!
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.loaded_gzip = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
--vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
--vim.g.loaded_python3_provider = 0 -- enable python 3 provider

vim.g.mapleader = " "
vim.g.maplocalleader = ";"
-- vim.g.rg_command = "rg --vimgrep -S"

-- Treesitter folding
vim.wo.foldmethod = "indent"
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- I am using Packer as my plugin manager
--
-- This is only possible because `install.sh` is bootsrapping my Vim
-- distro with packer installation
vim.cmd([[packadd packer.nvim ]])

-- ======================== PLUGINS MANAGEMENT ========================
require("packer").startup(function(use)
    -- Packer-in-Packer (PIP) to manage itself
    --
    -- This option allows to manage version updates
    -- for the packer plugin itself
    use({ "wbthomason/packer.nvim" })

    -- Pass me the harpoon for swift buffer navigation
    use("ThePrimeagen/harpoon")

    -- Refactoring
    use({ "ThePrimeagen/refactoring.nvim" })

    -- Treesitter
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-textobjects")

    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()
        end,
    })

    -- Fugitive for Git-integration
    --
    -- Run: `:h fugitive` to get started
    use("tpope/vim-fugitive")

    -- Extend plugin capabilities by providing
    -- high-level apis to extend vim native apis
    use("nvim-lua/plenary.nvim")

    -- Comment.nvim
    -- Comments are just awesome
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- GitHub Co-pilot
    use({ "github/copilot.vim" })

    -- Codemium (Free and sleeky)
    -- use 'Exafunction/codeium.vim'

    -- Glow for markdown preview
    use({
        "ellisonleao/glow.nvim",
        config = function()
            require("glow").setup()
        end,
    })

    --- LSP Config
    --- Langugue server management
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })

    -- LSP Support
    use({ "neovim/nvim-lspconfig" })
    -- Autocompletion
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
        },
    })

    -- Debugger Support
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    })

    use("theHamsta/nvim-dap-virtual-text")

    -- Terminal manager with Toggleterm
    -- https://github.com/akinsho/toggleterm.nvim.git
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("codemage.toggleterm")
        end,
    })

    -- Flutter
    -- Lsp integraton
    -- https://github.ocm/akinsho/flutter-tools.nvim
    use("akinsho/flutter-tools.nvim")

    -- Snippets
    use({ "L3MON4D3/LuaSnip" })
    use("rafamadriz/friendly-snippets")

    -- Formatter
    --
    -- TODO: remove when i comback to fix none-ls
    use("mhartington/formatter.nvim")

    -- Java LSP
    --
    -- For configuration, see: https://github.com/mfussenegger/nvim-jdtls
    -- use("mfussenegger/nvim-jdtls")

    -- Nvim Java
    --
    -- An all-in-one ready java plugin manager for vim
    -- https://github.com/nvim-java/nvim-java
    use({
        "nvim-java/nvim-java",
        requires = {
            "nvim-java/nvim-java-refactor",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "nvim-java/lua-async-await",
            "JavaHello/spring-boot.nvim",
        },
    })
    --
    -- SpringBoot nvim
    --
    -- https://github.com/JavaHello/spring-boot.nvim
    -- use({
    --     "JavaHello/spring-boot.nvim",
    --     config = function()
    --         require("spring_boot").setup({})
    --     end,
    -- })

    -- Test integration with Vim Test
    --
    -- The plugin allows granular control over how vim interacts
    -- with test suites and how tests are run.
    use("vim-test/vim-test")

    -- Fuzzy-matching with Telesecope
    --
    -- File explorer sucks, just fuzzy bro@
    use({ "nvim-telescope/telescope.nvim", tag = "0.1.5" })
    use("nvim-telescope/telescope-fzf-native.nvim", { run = "make" })

    -- UndoTree
    --
    -- Persist undos and redos in VCS format using algorithm similar to git trees
    use("mbbill/undotree")

    -- Themes (Tokyonight or Rose-pine)
    use({ "rose-pine/neovim", as = "rose-pine" })

    -- Autopairs
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    })

    -- Wakatime
    use("wakatime/vim-wakatime")

    -- Fomatting with None-ls
    -- Drop-in replacement for null-ls
    use("nvimtools/none-ls.nvim")

    -- Gruvbox
    use({ "ellisonleao/gruvbox.nvim" })

    use({
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        opts = {},
    })

    -- Vim Surround
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end,
    })

    -- Diffview
    -- Link: https://github.com/sindrets/diffview.nvim
    use("sindrets/diffview.nvim")
end)

-- ======================== MODULES ========================
require("codemage.mason")
require("codemage.lsp")
require("codemage.telescope")
require("codemage.keymaps")
require("codemage.null-ls")
require("codemage.toggleterm")
require("codemage.refactor")
require("codemage.colorscheme.gruvbox")

-- ======================== GLOBAL CONFIGURATION ========================
--
-- Vim options are settings that set the behaviour of a buffer or window.
-- Use: `:h options` or `:h options-list` for more infomation.
local options = {
    number = true,
    relativenumber = true,

    guicursor = "",
    termguicolors = true,

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    breakindent = true,
    smartindent = true,

    smartcase = true,
    ignorecase = true,

    wrap = false,

    scrolloff = 8,
    sidescrolloff = 6,

    hlsearch = false,
    incsearch = true,

    splitright = true,
    splitbelow = true,

    undodir = vim.fn.expand("$HOME/.vim/undodir"),
    undofile = true,
    swapfile = false,

    -- Time before writing to swap file
    --
    -- Since we set swap file to false, won't be needing this anyway but
    -- its what it is
    updatetime = 100,

    hidden = false,

    backspace = { "start", "eol", "indent" },
    signcolumn = "yes",
    guifont = "Fira Code",
}

for conf, val in pairs(options) do
    vim.opt[conf] = val
end

-- Just ignore `node_modules` and `.git`. Seriously, its the worst place
-- to be in the universe
vim.opt.wildignore:append({ ".git", ".venv", "*/node_modules/*" })

vim.opt.path:append({ "**" })
vim.opt.isfname:append("@-@")
-- ======================== USER/AUTOCOMMANDS ========================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local highlight_text = augroup("TextHighlight", { clear = true })

autocmd("BufWritePre", {
    callback = function()
        if vim.bo.ft == "java" then
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                apply = true,
            })
        end

        -- if vim.bo.ft == "python" then
        --     vim.lsp.buf.code_action({
        --         context = { only = { "source.organizeImports" } },
        --         apply = true,
        --     })
        -- end
    end,
})

autocmd("TextYankPost", {
    group = highlight_text,
    callback = function()
        vim.highlight.on_yank()
    end,
    pattern = "*",
})

-- Persist last known cursor location across sessions
local jump_to_lastloc = augroup("JumpToLastLocation", { clear = true })
autocmd("BufReadPost", {
    group = jump_to_lastloc,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

autocmd({ "FileReadPre", "BufRead" }, {
    pattern = { "json", "jsonc", "markdown" },
    callback = function()
        vim.wo.conceallevel = 0
    end,
})
-- ======================== KEYMAPS ========================
--
local keymap = vim.keymap

-- Unbind space to leader key
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- getting used to Ctrl+c is not my thing
keymap.set("i", "<C-c>", "<Nop>")

-- Use system clipboards instead of Vim's built-in clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+Y')
keymap.set({ "v" }, "<localleader>y", '"+y')
keymap.set({ "n", "v" }, "<leader>d", '"_d')
keymap.set("n", "<leader>p", '"+P')

-- Navigation is better with `project-view`
keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- -- Quickly jummp out of the terminal with Ctrl+c
-- keymap.set("t", "<C-c>", "<C-\\><C-n>:q<cr>")
--
-- vim.api.nvim_set_keymap(
--     "t",
--     "<C-q>",
--     "<C-d>",
--     { noremap = true, silent = true }
-- )
--
-- Quickly jummp out of the terminal with kj
-- vim.api.nvim_set_keymap(
--     "t",
--     "<localleader>q",
--     "<C-\\><C-n>",
--     { noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
--     "t",
--     "jk",
--     "<C-\\><C-n>",
--     { noremap = true, silent = true }
-- )

vim.api.nvim_set_keymap(
    "n",
    "<Leader>fc",
    ":q<CR>",
    { noremap = true, silent = true }
)

-- Fast way to save and exit a file
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "[w]rite [b]uffer" })

-- Navigate up, down, left, and right between splits.
vim.keymap.set("n", "<C-h>", "<c-w>h")
vim.keymap.set("n", "<C-j>", "<c-w>j")
vim.keymap.set("n", "<C-k>", "<c-w>k")
vim.keymap.set("n", "<C-l>", "<c-w>l")

-- Glow preview (for markdowns)
-- pm means, preview markdown
vim.keymap.set(
    "n",
    "<leader>pmf",
    ":Glow<CR>",
    { desc = "[p]review [m]arkdown [f]ile" }
)

-- Better way to jump out of modes
keymap.set({ "i", "v", "x" }, "jk", "<Esc>")

keymap.set("n", "Q", "<nop>")
keymap.set("n", "<leader>qq", "<cmd>q!<cr>")
keymap.set("n", "<leader>wq", "<cmd>wq<cr>")
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "[q]uit [b]uffer" })

-- Search-replace
vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)

-- Undo tree for the Win!
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

--- Git bindings
keymap.set("n", "<leader>gs", function()
    vim.cmd([[ Git ]])
end)
keymap.set("n", "<leader>ga", function()
    vim.cmd([[ Git add % ]])
end)
keymap.set("n", "<leader>gc", function()
    vim.cmd([[ Git commit ]])
end)

-- Make text selection move up and down in selection mode
keymap.set("v", "J", ":m '>+1<cr>gv=gv")
keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Use <Ctrl-x'> to make a bash script executable
keymap.set("n", "<leader>x", "<cmd>silent !chmod +x %<cr>")

keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sess-man<cr>")

-- Keep cursor at the middle of the buffer at all times
-- ..when Ctrl+d is pressed to scroll to the bottom of the page
-- ..and when the reverse is done with Ctrl+u
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Quickfist list, LocLists and Buffers
keymap.set("n", "<leader>nc", ":cnext<cr>")
keymap.set("n", "<leader>pc", ":cprev<cr>")
keymap.set("n", "<leader>nb", ":bnext<cr>")
keymap.set("n", "<leader>pb", ":bprev<cr>")
keymap.set("n", "<leader>nl", ":lnext<cr>")
keymap.set("n", "<leader>pl", ":lprev<cr>")

-- window management
keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>") -- descreses width
keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>") -- increase width to the right
keymap.set("n", "<A-j>", "<cmd>resize -2<cr>") -- decrease height
keymap.set("n", "<A-k>", "<cmd>resize +2<cr>") -- increase height

keymap.set("n", "<leader><leader>", function()
    vim.cmd([[ so % ]])
end)

-- ======================== PLUGINS CONFIGURATION ========================
--
-- ******************************** Harpoon ********************************
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ha", function()
    mark.add_file()
end)
vim.keymap.set("n", "<leader>hh", function()
    ui.toggle_quick_menu()
end)

vim.keymap.set("n", "<leader>haa", function()
    ui.nav_file(1)
end, { desc = "[h]arpoon [s]witch [f]irst" })
vim.keymap.set("n", "<leader>hss", function()
    ui.nav_file(2)
end, { desc = "[h]arpoon [s]witch [s]econd" })
vim.keymap.set("n", "<leader>hdd", function()
    ui.nav_file(3)
end, { desc = "[h]arpoon [s]witch [t]hird" })
vim.keymap.set("n", "<leader>hff", function()
    ui.nav_file(4)
end, { desc = "[h]arpoon [s]witch [l]ast" })

--
-- ******************************** Tests ********************************
vim.g["test#strategy"] = "neovim"
vim.g["test#strategy#suite"] = "vimux"
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#neovim#term_repl_command"] = "vsplit"

-- SPLITS WITH MAPPING
--
keymap.set("n", ";sp", ":sp<CR>")

keymap.set("n", ";vs", ":vsp<CR>")
