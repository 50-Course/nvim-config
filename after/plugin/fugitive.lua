local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local git_keymaps = function()
    local opts = { noremap = true, silent = true}

    vim.keymap.set("n", "<leader>gs", ":Git<CR>", opts)
    -- Git push
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", opts)
    -- Always rebase
    vim.keymap.set("n", "<leader>P", function()
        -- if there are changes, stash them, pull, then pop the stash
        -- otherwise just pull
        vim.cmd.Git('stash')
        -- rebase and display the log in a split
        vim.cmd [[Git pull origin --rebase | copen]]
        vim.cmd.Git('stash pop')
    end, opts)

    -- Git push to named branch
    vim.keymap.set("n", "<leader>pt", function()
        local branch = vim.fn.input("Branch: ")
        vim.cmd.Git({ "push", "-u", "origin", branch })
    end, opts)

    -- add and push tags interactively
    vim.keymap.set("n", "<leader>ptt", function()
        vim.cmd.Git("tag -l | fzf | xargs git push origin")
    end, opts)
end

augroup("CodemageFugitive", {})
autocmd("BufWinEnter", {
    group = "CodemageFugitive",
    pattern = "*",
    callback = git_keymaps,
})
