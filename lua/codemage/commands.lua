-- ======================== USER/AUTOCOMMANDS ========================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local highlight_text = augroup("TextHighlight", { clear = true })

autocmd("BufWritePre", {
    callback = function()
        if vim.bo.ft == "java" then
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                apply = true,
            })
        end

        -- if vim.bo.ft == "python" then
        --     vim.lsp.buf.code_action({
        --         context = { only = { "source.organizeImports" } },
        --         apply = true,
        --     })
        -- end
    end,
})

autocmd("TextYankPost", {
    group = highlight_text,
    callback = function()
        vim.highlight.on_yank()
    end,
    pattern = "*",
})

-- Persist last known cursor location across sessions
local jump_to_lastloc = augroup("JumpToLastLocation", { clear = true })
autocmd("BufReadPost", {
    group = jump_to_lastloc,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

autocmd({ "FileReadPre", "BufRead" }, {
    pattern = { "json", "jsonc", "markdown" },
    callback = function()
        vim.wo.conceallevel = 0
    end,
})
