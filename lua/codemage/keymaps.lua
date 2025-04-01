--- Home of all personal keybinds
---
--- Created 2025-01-20 04:19:26

--- Default mappings for toggle terminal
---
--- Allows for terminal movement quickly exiting the terminal and process cancellation

local M = {}

function _G.set_git_bindings()
    local keymap = vim.keymap

    keymap.set("n", "<leader>gs", function()
        vim.cmd([[ Git ]])
    end)
    keymap.set("n", "<leader>ga", function()
        vim.cmd([[ Git add % ]])
    end)
    keymap.set("n", "<leader>gc", function()
        vim.cmd([[ Git commit ]])
    end)
end

function _G.set_win_binds()
    -- window management
    vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>") -- descreses width
    vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>") -- increase width to the right
    vim.keymap.set("n", "<A-j>", "<cmd>resize -2<cr>")          -- decrease height
    vim.keymap.set("n", "<A-k>", "<cmd>resize +2<cr>")          -- increase height

    -- Navigate up, down, left, and right between splits.
    vim.keymap.set("n", "<C-h>", "<c-w>h")
    vim.keymap.set("n", "<C-j>", "<c-w>j")
    vim.keymap.set("n", "<C-k>", "<c-w>k")
    vim.keymap.set("n", "<C-l>", "<c-w>l")

    -- Better way to jump out of modes
    vim.keymap.set({ "i", "v", "x" }, "jk", "<Esc>")

    vim.keymap.set("n", "Q", "<nop>")
    vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>")
    vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>")
    vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "[q]uit [b]uffer" })

    -- Fast way to save and exit a file
    vim.keymap.set(
        "n",
        "<leader>w",
        "<cmd>w<cr>",
        { desc = "[w]rite [b]uffer" }
    )

    -- Navigation is better with `project-view`
    vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

    -- SPLITS WITH MAPPING
    --
    vim.keymap.set("n", ";sp", ":sp<CR>")
    vim.keymap.set("n", ";vs", ":vsp<CR>")
end

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
