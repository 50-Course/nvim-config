------------------------------------------
--- PERSONAL DEVELOPMENT ENVIRONMENT
---
--- 2024 is the year of efficiency and winnings - I can feel it! - Jan 7, 24
--- Author: Eri (@50Course/@codemage)
--- License: MIT License
------------------------------------------

--- Disable VIM defaults
-- Nobody likes the top banner on NetRW -- I don't!
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.loaded_gzip = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

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
    use({ "wbthomason/packer.nvim", opt = true })

    -- Pass me the harpoon for swift buffer navigation
    use("ThePrimeagen/harpoon")

    -- Treesitter
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-textobjects")

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

    -- Null LS
    use("jose-elias-alvarez/null-ls.nvim")

    -- GitHub Co-pilot
    use("github/copilot.vim")

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
            "hrsh7th/cmp-nvim-lua",
        },
    })
    -- Snippets
    use({ "L3MON4D3/LuaSnip" })
    use("rafamadriz/friendly-snippets")

    -- Java LSP
    --
    -- For configuration, see: https://github.com/mfussenegger/nvim-jdtls
    use("mfussenegger/nvim-jdtls")

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

    -- You never know when i'd be dealing with Web Dev
    --
end)

require("lsp")

-- ======================== GLOBAL CONFIGURATION ========================
--
-- Vim options are settings that set the behaviour of a buffer or window.
-- Use: `:h options` or `:h options-list` for more infomation.
local options = {
    number = true,
    relativenumber = true,

    termguicolors = true,
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
    undofile = false,
    swapfile = false,
    updatetime = 100,
    hidden = false,
    softtabstop = 4,
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    signcolumn = "yes",
}

for conf, val in pairs(options) do
    vim.opt[conf] = val
end

-- Just ignore `node_modules` and `.git`. Seriously, its the worst place
-- to be in the universe
vim.opt.wildignore:append({ ".git", ".venv", "node_modules" })

-- ======================== USER/AUTOCOMMANDS ========================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local highlight_text = augroup("TextHighlight", { clear = true })
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

-- ======================== KEYMAPS ========================
--
local keymap = vim.keymap

-- Unbind space to leader key
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- getting used to Ctrl+c is not my thing
keymap.set("i", "<C-c>", "<Nop>")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Use system clipboards instead of Vim's built-in clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+Y')
keymap.set({ "n", "v" }, "<leader>d", '"_d')
keymap.set("n", "<leader>p", '"+P')

-- Navigation is better with `project-view`
keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Navigate up, down, left, and right between splits.
vim.keymap.set("n", "<C-h>", "<c-w>h")
vim.keymap.set("n", "<C-j>", "<c-w>j")
vim.keymap.set("n", "<C-k>", "<c-w>k")
vim.keymap.set("n", "<C-l>", "<c-w>l")

-- Better way to jump out of modes
keymap.set({ "i", "v", "x" }, "jk", "<Esc>")

keymap.set("n", "Q", "<nop>")

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
keymap.set("n", "<leader>gco", function()
    vim.cmd([[ Git checkout ]])
end)

-- Make text selection move up and down in selection mode
keymap.set("v", "J", ":m '>+1<cr>gv=gv")
keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Use <Ctrl-x'> to make a bash script executable
keymap.set("n", "<C-x>", "<cmd>silent !chmod +x %<cr>")

-- Keep cursor at the middle of the buffer at all times
-- ..when Ctrl+d is pressed to scroll to the bottom of the page
-- ..and when the reverse is done with Ctrl+u
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Vim Tests keybinds
keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>")
keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>")
keymap.set("n", "<leader>ts", "<cmd>TestSuite<cr>")
keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>")

-- window management
keymap.set("n", "<C-S-Right>", "<cmd>:vertical resize -1<cr>")
keymap.set("n", "<C-S-Left>", "<cmd>:vertical resize +1<cr>")

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
vim.keymap.set("n", "<S-h>", function()
    ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>j", function()
    ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>k", function()
    ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>l", function()
    ui.nav_file(4)
end)

-- ******************************** Telescope ********************************
pcall(require("telescope").load_extension, "fzf")

local builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup({
    pickers = {
        find_files = {
            previewer = false,
        },
        buffers = {
            previewer = false,
        },
        live_grep = {
            previewer = false,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
})

vim.keymap.set("n", "<leader>ff", function()
    if vim.fn.isdirectory(".git") == 1 then
        -- Run git files search
        builtin.git_files()
    else
        -- Regular file search
        builtin.find_files()
    end
end, {})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {})
vim.keymap.set("n", "<leader>fs", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", function()
    builtin.buffers()
end, {})

-- ******************************** Tests ********************************
vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#neovim#term_repl_command"] = "vsplit"
