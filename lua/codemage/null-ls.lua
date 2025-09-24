local _, null_ls = pcall(require, "null-ls")

-- gives us the superpowers to  manupulate how the lsp interact
local _, lspconfig_util = pcall(require, "lspconfig/util")

local root_files = {
    "pyproject.toml",
    ".git",
    "pom.xml",
    "build.gradle",
}

local sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring.with({
        filetypes = {
            "javascript",
            "typescript",
            "go",
            "lua",
        },
    }),
    null_ls.builtins.formatting.prettierd.with({
        filetypes = {
            "html",
            "json",
            "yaml",
            "markdown",
            "css",
            "scss",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
        },
    }),
    null_ls.builtins.diagnostics.cppcheck,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.clang_format.with({
        filetypes = { "c", "cpp", "objc", "objcpp" },
    }),
    null_ls.builtins.diagnostics.pylint,
    -- null_ls.builtins.diagnostics.pylint.with({
    --     -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    --     -- diagnostics_postprocess = function(diagnostic)
    --     --     diagnostic.code = diagnostic.message_id
    --     -- end,
    --     env = function(params)
    --         return { PYTHONPATH = params.root }
    --     end,
    -- }),
    null_ls.builtins.hover.dictionary,
    null_ls.builtins.diagnostics.mypy,
    -- null_ls.builtins.diagnostics.mypy.with({
    --     extra_args = function(params)
    --         -- dynamically find the root directory
    --         local root_dir =
    --             lspconfig_util.root_pattern(unpack(root_files))(params.bufname)
    --
    --         if root_dir then
    --             return {
    --                 "--config-file",
    --                 root_dir .. "/pyproject.toml",
    --             }
    --         else
    --             return {}
    --         end
    --     end,
    -- }),
}

local attach_to_lsp = function(client, bufnr)
    local ignore_formatting_for_filetypes = { "python" }
    local filetype = vim.bo[bufnr].filetype

    if
        client.server_capabilities.documentFormattingProvider
        and not vim.tbl_contains(ignore_formatting_for_filetypes, filetype)
    then
        vim.api.nvim_create_augroup("Format", { clear = true })
        vim.api.nvim_clear_autocmds({ group = "Format", buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = "Format",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 2000, bufnr = bufnr })
            end,
        })
        -- vim.cmd([[augroup Format]])
        -- vim.cmd([[autocmd! * <buffer>]])
        -- vim.cmd(
        --     [[autocmd BufWritePost <buffer> lua vim.lsp.buf.format({timeout_ms = 2000})]]
        -- )
        -- vim.cmd([[augroup END]])
    end
end

null_ls.setup({ debug = false, sources = sources, on_attach = attach_to_lsp })
