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
local disabled_providers = {
    "gzip",
    "node_provider",
    "perl_provider",
    "ruby_provider",
    "python_provider",
}

for _, provider in ipairs(disabled_providers) do
    vim.g["loaded_" .. provider] = 0
end

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
--vim.g.loaded_python3_provider = 0 -- enable python 3 provider

vim.g.mapleader = " "
vim.g.maplocalleader = ";"
-- vim.g.rg_command = "rg --vimgrep -S"

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
    use({ "github/copilot.vim", disable = true })

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
    use("akinsho/flutter-tools.nvim", { cond = false })

    -- Snippets
    use({ "L3MON4D3/LuaSnip" })
    use("rafamadriz/friendly-snippets")

    -- Formatter
    --
    -- TODO: remove when i comback to fix none-ls
    use("mhartington/formatter.nvim")

    -- Tests with Nvim-test
    use("klen/nvim-test")

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

    -- Tokyonight colorscheme
    use({
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        opts = {},
    })

    -- Catappuccin colorscheme
    --
    -- Ref: https://github.com/catppuccin/nvim#Compile
    use({ "catppuccin/nvim", as = "catppuccin" })

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
require("codemage.options")
require("codemage.telescope")
require("codemage.keymaps")
require("codemage.null-ls")
require("codemage.toggleterm")
require("codemage.refactor")
require("codemage.commands")
require("codemage.harpoon")
require("codemage.colorscheme.gruvbox")
require("codemage.colorscheme.catappucin")

-- ======================== KEYMAPS ========================
--
local keymap = vim.keymap

-- Unbind space to leader key
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- getting used to Ctrl+c is not my thing
keymap.set("i", "<C-c>", "<Nop>")

vim.api.nvim_set_keymap(
    "n",
    "<Leader>fc",
    ":q<CR>",
    { noremap = true, silent = true }
)

-- Glow preview (for markdowns)
-- pm means, preview markdown
vim.keymap.set(
    "n",
    "<leader>pmf",
    ":Glow<CR>",
    { desc = "[p]review [m]arkdown [f]ile" }
)

-- Undo tree for the Win!
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

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

-- reload nvim configuration
keymap.set("n", "<leader><leader>", function()
    vim.notify("Reloading nvim configuration...", vim.log.levels.INFO)
    vim.cmd([[ source $MYVIMRC ]])
    vim.notify("Vim config reloaded!", vim.log.levels.INFO)
end)

--
-- ******************************** Tests ********************************
vim.g["test#strategy"] = "neovim"
vim.g["test#strategy#suite"] = "vimux"
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#neovim#term_repl_command"] = "vsplit"
