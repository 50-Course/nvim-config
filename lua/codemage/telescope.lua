--- Provide configuration for telescope and friends
---
--- Features my telescope configuration for FZF, Grep, and Test picking
---
-- ******************************** Telescope ********************************
pcall(require("telescope").load_extension, "fzf")

local M = {}

local test = require("nvim-test")
local builtin = require("telescope.builtin")
local telescope = require("telescope")
local picka = require("telescope.pickers")
local picker = picka.new

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
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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

    -- find lsp document symbols in the current buffer
    map("n", "<leader>fS", function()
        builtin.lsp_document_symbols()
    end, { desc = "Find LSP Document Symbols" })

    -- find in current buffer
    map("n", "<leader>fB", function()
        builtin.current_buffer_fuzzy_find()
    end, { desc = "Find in Current Buffer" })

    -- find lsp references
    map("n", "<leader>vrr", function()
        builtin.lsp_references()
    end, { desc = "Find LSP References" })

    -- find lsp implementations
    map("n", "<leader>vI", function()
        builtin.lsp_implementations()
    end, { desc = "Find LSP Implementations" })

    -- find type definitions
    map("n", "<leader>vD", function()
        builtin.lsp_type_definitions()
    end, { desc = "Find LSP Type Definitions" })

    -- -- find tests
    -- map("n", "<leader>tT", function()
    --     M.run_tests()
    -- end, { desc = "Run Tests" })
end

--- Pick and Run specific tests with Telescope
function M.run_tests()
    local tests = test.get_tests()

    if not tests or #tests == 0 then
        vim.notify("No tests found", vim.log.levels.ERROR)
        return
    end

    -- get the test entries
    local test_entries = {}
    for _, t in ipairs(tests) do
        table.insert(
            test_entries,
            { value = t.name, ordinal = t.name, display = t.name }
        )
    end

    -- create the picker
    picker({
        prompt_title = "Select Test",
        selection_caret = "> ",
        finder = {
            entry_maker = function(entry)
                return {
                    display = entry.display,
                    ordinal = entry.ordinal,
                    value = entry.value,
                }
            end,
            results = test_entries,
        },
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local run_test = function()
                local selection = picker.get_selected_entry(prompt_bufnr)
                if not selection then
                    return
                end

                test.run({ selection.value })
            end

            map("i", "<CR>", run_test)
            map("n", "<CR>", run_test)

            return true
        end,
    }):find()
end

M.setup_telescope_keybinds()

return M
