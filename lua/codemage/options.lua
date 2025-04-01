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
