--- Home of all personal keybinds
---
--- Created 2025-01-20 04:19:26

--- Default mappings for toggle terminal
---
--- Allows for terminal movement quickly exiting the terminal and process cancellation
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
