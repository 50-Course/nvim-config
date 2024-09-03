local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local git_keymaps = function()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>gs", ":Git<CR>", opts)
    -- Git push
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", opts)
    -- Always rebase
    vim.keymap.set("n", "<leader>P", function()
        -- if there are changes, stash them, pull, then pop the stash
        -- otherwise just pull
        vim.cmd.Git("stash")
        -- rebase and display the log in a split
        vim.cmd([[Git pull origin --rebase | copen]])
        vim.cmd.Git("stash pop")
    end, opts)


    -- Git push to named branch
    vim.keymap.set("n", "<leader>pb", function()
        local branch = vim.fn.input("Branch: ")
        vim.cmd.Git({ "push", "-u", "origin", branch })
    end, opts)

    vim.keymap.set('n', '<leader>gdv', function()
        vim.cmd('Gvdiffsplit %')
    end, opts)

    vim.keymap.set('n', '<leader>gds', function()
        vim.cmd('Gvdiffsplit')
    end, opts)

    vim.keymap.set('n', '<leader>gdc', function()
        vim.cmd('Gvdiffsplit | wincmd p')
    end, opts)

    vim.keymap.set("n", "<leader>gco", function()
        local _, telescope_builtin = pcall(require, "telescope.builtin")
        local branch_name = vim.fn.input("Branch name: ")

        if branch_name == "" then
            print("Branch name cannot be empty")
            return
        end

        local branch_exists =
            vim.fn.system("git rev-parse --verify " .. branch_name)

        if branch_exists then
            telescope_builtin.git_branches({
                attach_mappings = function(_, map)
                    map("i", "<CR>", function(bufnr)
                        local entry =
                            require("telescope.actions.state").get_selected_entry(
                                bufnr
                            )
                        require("telescope.actions").close(bufnr)
                        vim.cmd("Git checkout " .. entry.value)
                    end)
                    return true
                end,
            })
        else
            vim.cmd("Git checkout -b " .. branch_name)
        end

        -- Use telescope to confirm switching branches
        --
    end, opts)

    -- add and push tags interactively
    -- TODO: implement this
    vim.keymap.set("n", "<leader>gpt", function()
        -- local _, telescope_builtin = pcall(require, "telescope.builtin")

        -- UPDATE: this is not working as expected, I am able to see the list of tags,
        -- but I am not able to select them and push them - I am thnking of using
        -- fzf and piping the output to git push

        -- local tag_name = vim.fn.input("Tag name: ")
        -- vim.cmd.Git("tag " .. tag_name)
        -- local tags = vim.fn.systemlist("git tag -l")
        --
        -- if not tags[tag_name] then
        --    vim.cmd.Git("tag " .. tag_name)
        --    tags = vim.fn.systemlist("git tag -l")
        --    print(vim.inspect(tags))
        -- --
        -- -- if tag exists, push it
        -- print(vim.inspect(tags))

        local tag_name = vim.fn.input("Tag name: ")
        vim.cmd.Git("tag " .. tag_name)
        vim.cmd.Git({ "push", "--tags", tag_name })
        print("Pushed " .. tag_name .. " to remote")
    end, opts)

    -- List all Git tags available
    vim.keymap.set("n", "<leader>gt", function()
        local _, telescope_builtin = pcall(require, "telescope.builtin")

        local tag_name = vim.fn.input("Tag name: ")
        local tags = vim.fn.systemlist("git tag -l")
        if tags[tag_name] then
            print(vim.inspect(tags))
        end
    end, opts)
end

augroup("CodemageFugitive", {})
autocmd("BufWinEnter", {
    group = "CodemageFugitive",
    pattern = "*",
    callback = git_keymaps,
})
