local opts = { noremap = true, silent = true }

--- simple generic function to map keybinds
local map = function(mode, keybind, command, opts)
    vim.api.nvim_set_keymap(mode, keybind, command, opts or {})
end

local augroup = vim.api.nvim_create_augroup("GTest", { clear = true })
local autocmd = vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "cpp",
    callback = function()
        map("n", "<leader>tt", ":GTestRun %<CR>", opts)
    end,
})
