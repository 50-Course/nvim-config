--- Provide configuration for telescope and friends
---
--- Features my telescope configuration for FZF, Grep, and Test picking
---
-- ******************************** Telescope ********************************
pcall(require("telescope").load_extension, "fzf")

local M = {}
local builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup({
    pickers = {
        find_files = {
            previewer = false,
        },
        buffers = {
            previewer = false,
        },
        live_grep = {
            previewer = false,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
})

function M.setup_telescope_keybinds()
    local map = vim.keymap.set

    map("n", "<leader>ff", function()
        if vim.fn.isdirectory(".git") == 1 then
            -- Run git files search
            builtin.git_files()
        else
            -- Regular file search
            builtin.find_files()
        end
    end, {})

    map("n", "<leader>vh", builtin.help_tags, { desc = "View Help Tags" })
    map("n", "<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Project Search" })
    map("n", "<leader>fs", builtin.live_grep, {})
    map("n", "<leader>fb", function()
        builtin.buffers()
    end, { desc = "Find Buffers" })
end

M.setup_telescope_keybinds()

return M
