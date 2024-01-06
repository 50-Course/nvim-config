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
	use 'wbthomason/packer.nvim'

	-- Pass me the harpoon for swift buffer navigation
	use 'ThePrimeagen/harpoon.nvim'

	-- Treesitter
	use 'nvim-treesitter/nvim-treesitter'

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
	autoindent = true,
	smartcase = true,
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
}

for conf, val in pairs(options) do
	vim.opt[conf] = val
end

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

-- ======================== KEYMAPS ========================
--
local keymap = vim.keymap

-- Unbind space to leader key
keymap.set('n', '<Space>', '<Nop>')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','


-- Use system clipboards instead of Vim's built-in
keymap.set({'n', 'v'}, '<leader>y', '"+Y')
keymap.set({'n', 'v'}, '<leader>d', '"_d')
keymap.set('n', '<leader>p', '"dP')

keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Better way to jump out of modes
keymap.set({'i', 'v', 'x'}, 'jk', '<Esc>')
keymap.set({'i', 'v', 'x'}, 'kj', '<Esc>')

keymap.set('n', 'Q', '<nop>')
