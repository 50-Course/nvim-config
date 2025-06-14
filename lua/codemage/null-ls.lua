local _, null_ls = pcall(require, "null-ls")

-- gives us the superpowers to  manupulate how the lsp interact
local _, lspconfig_util = pcall(require, "lspconfig/util")

local root_files = {
    "pyproject.toml",
    ".git",
    "pom.xml",
    "build.gradle",
}

-- Sources
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

local sources = {
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring.with({
        filetypes = {
            "python",
            "javascript",
            "typescript",
            "go",
            "lua",
        }, }),
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
    -- null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.clang_format.with({
        filetypes = { "c", "cpp", "objc", "objcpp" },
    }),
    null_ls.builtins.formatting.djlint,
    -- null_ls.builtins.diagnostics.pylint.with({
    --     -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    --     -- diagnostics_postprocess = function(diagnostic)
    --     --     diagnostic.code = diagnostic.message_id
    --     -- end,
    --     env = function(params)
    --         return { PYTHONPATH = params.root }
    --     end,
    -- }),
    -- null_ls.builtins.diagnostics.semgrep.with({
    --     filetypes = { "java", "typescript", "go" },
    -- }),
    null_ls.builtins.hover.dictionary,
    -- null_ls.builtins.formatting.remark,
    null_ls.builtins.formatting.isort,
    -- diagnostics.mypy,
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
    -- null_ls.builtins.formatting.dart_format,
    -- null_ls.builtins.formatting.npm_groovy_lint.with({
    --     filetypes = { "groovy", "jenkinsfile" },
    -- }),
}

local attach_to_lsp = function(client)
    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[augroup Format]])
        vim.cmd([[autocmd! * <buffer>]])
        vim.cmd(
            [[autocmd BufWritePost <buffer> lua vim.lsp.buf.format({timeout_ms = 2000})]]
        )
        vim.cmd([[augroup END]])
    end
end

null_ls.setup({ debug = false, sources = sources, on_attach = attach_to_lsp })
