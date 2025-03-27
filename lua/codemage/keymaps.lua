--- Home of all personal keybinds
---
--- Created 2025-01-20 04:19:26

--- Default mappings for toggle terminal
---
--- Allows for terminal movement quickly exiting the terminal and process cancellation

local M = {}

function _G.set_terminal_bindings()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_bindings()")

--- Keybinds for Formatting
---
--- Uses the `formatter.nvim` plugin to format code
---
--- not sure i have gotten this to work properly, but it should be fine
function M.set_format_bindings()
    vim.keymap.set("n", "<localleader>f", ":Format<CR>")
    vim.keymap.set("n", "<localleader>F", ":FormatWrite<CR>")
end

-- - Keybinds for Testing
--
-- this is an anonymous function that sets up the keymaps for testing
M.setup_test_keymaps = function()
    vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>")
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>")
end

M.set_format_bindings()
M.setup_test_keymaps()

return M
