-- I am using Packer as my plugin manager

vim.cmd [[packadd packer.nvim ]]

-- ======================== PLUGINS MANAGEMENT ========================
require('packer').setup(function(use)

	-- Packer-in-Packer (PIP) to manage itself
	--
	-- This option allows to manage version updates
	-- for the packer plugin itself
	use 'wbthomason/packer.nvim'


end)


-- ======================== GLOBAL CONFIGURATION ========================
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
}

for conf, val in ipairs(options) do
	vim.opt[conf] = val
end



