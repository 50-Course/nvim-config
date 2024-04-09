local toggleterm = require("toggleterm")

toggleterm.setup({
    -- Dynamically set size based on positions
    -- NOTE: size can be a number or a function which is passed as
    -- as a reference to the current terminal
    size = function(terminal)
        if terminal.direction == "horizontal" then
            return 15
        elseif terminal.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    open_mapping = [[<leader>vt]],
    direction = "vertical",
    close_on_exit = true,
})

vim.keymap.set('n', '<leader>vth', [[:ToggleTerm direction=horizontal<CR>]])
vim.keymap.set('n', '<leader>vt', [[:ToggleTerm direction=vertical<CR>]])
