function no_bg_color()
    -- essentially, we set the background, full transparency
    --
    -- Vim refers to the current window as `Normal` and floating windows as `NormalFloat`
    --
    -- for more information, seek the documentation `:h `
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local status, rose_pine = pcall(require, "rose-pine")

vim.cmd("colorscheme tokyonight-night")

vim.keymap.set("n", "<leader>nbg", function()
    vim.cmd([[hi Normal guibg=None ctermbg=None]])
end)
