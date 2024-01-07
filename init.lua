-- I am using Packer as my plugin manager
--
-- This is only possible because `install.sh` is bootsrapping my Vim
-- distro with packer installation
vim.cmd [[packadd packer.nvim ]]

-- ======================== PLUGINS MANAGEMENT ========================
require('packer').startup(function(use)

	-- Packer-in-Packer (PIP) to manage itself
	--
	-- This option allows to manage version updates
	-- for the packer plugin itself
	use { 'wbthomason/packer.nvim', opt = true }

	-- Pass me the harpoon for swift buffer navigation
	use 'ThePrimeagen/harpoon'

	-- Treesitter
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- Fugitive for Git-integration
    --
    -- Run: `:h fugitive` to get started
    use 'tpope/vim-fugitive'

    -- Extend plugin capabilities by providing 
    -- high-level apis to extend vim native apis
    use 'nvim-lua/plenary.nvim'

    -- Java LSP
    --
    -- For configuration, see: https://github.com/mfussenegger/nvim-jdtls
    use 'mfussenegger/nvim-jdtls'

    -- Test integration with Vim Test
    --
    -- The plugin allows granular control over how vim interacts 
    -- with test suites and how tests are run.
    -- See: https://github.com/vim-test/vim-test/blob/master/README.md
    use 'vim-test/vim-test'


    -- Fuzzy-matching with Telesecope
    --
    -- File explorer sucks, just fuzzy bro@
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.5' }

    -- You never know when i'd be dealing with Web Dev
    --
    -- 

end)


-- ======================== GLOBAL CONFIGURATION ========================
--
-- Vim options are settings that set the behaviour of a buffer or window.
-- Use: `:h options` or `:h options-list` for more infomation.
local options = {
	number = true,
	relativenumber = true,

	termguicolors = true,
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
	undodir = vim.fn.expand('$HOME/.vim/undodir'),
	undofile = false,
	swapfile = false,
	updatetime = 50,

	softtabstop = 4,
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true
}

for conf, val in pairs(options) do
	vim.opt[conf] = val
end

-- Just ignore `node_modules` and `.git`. Seriously, its the worst place
-- to be in the universe
-- vim.opt.wildignore += '**/.git/*'
-- vim.opt.wildignore += '**/node_modules/*'


--- Disable VIM defaults
-- Nobody likes the top banner on NetRW -- I don't!
vim.g.netrw_banner = 0
vim.g.loaded_shada = 1
vim.g.loaded_gzip = 1

-- ======================== USER/AUTOCOMMANDS ========================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local highlight_text = augroup('TextHighlight', {clear = true })
autocmd('TextYankPost', {
	group = highlight_text,
	callback = function()
		vim.highlight.on_yank()

	end,
	pattern = '*'
})

-- Persist last known cursor location across sessions
local jump_to_lastloc = augroup('JumpToLastLocation', {clear = true })
autocmd('BufReadPost', {
	group = jump_to_lastloc,
	callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
	end
})


-- ======================== KEYMAPS ========================
--
local keymap = vim.keymap

-- Unbind space to leader key
keymap.set('n', '<Space>', '<Nop>')
-- getting used to Ctrl+c is not my thing
keymap.set('i', '<C-c>', '<Nop>')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','


-- Use system clipboards instead of Vim's built-in clipboard
keymap.set({'n', 'v'}, '<leader>y', '"+Y')
keymap.set({'n', 'v'}, '<leader>d', '"_d')
keymap.set('n', '<leader>p', '"+P')

-- Navigation is better with `project-view`
keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Better way to jump out of modes
keymap.set({'i', 'v', 'x'}, 'jk', '<Esc>')

keymap.set('n', 'Q', '<nop>')

--- Git bindings
keymap.set('n', '<leader>gs', function() vim.cmd [[ Git ]] end)

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


-- ======================== PLUGINS CONFIGURATION ========================


