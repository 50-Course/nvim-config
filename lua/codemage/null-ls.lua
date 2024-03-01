local _, null_ls = pcall(require, "null-ls")

local sources = {
    null_ls.builtins.diagnostics.eslint.with({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    }),
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.prettierd.with({
	filetypes = { "html", "json", "yaml", "markdown" },
    }),
    null_ls.builtins.formatting.clang_format.with({
	filetypes = { "c", "cpp", "objc", "objcpp" },
    }),
    null_ls.builtins.formatting.djlint,
    null_ls.builtins.formatting.dart_format,
    null_ls.builtins.formatting.npm_groovy_lint.with({
	filetypes = { "groovy", "jenkinsfile" },
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.shfmt,
}

null_ls.setup({ sources = sources })
