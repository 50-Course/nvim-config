local _, null_ls = pcall(require, "null-ls")

local sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.prettierd.with({
	filetypes = { "html", "json", "yaml", "markdown" },
    }),
    null_ls.builtins.formatting.clang_format.with({
	filetypes = { "c", "cpp", "objc", "objcpp" },
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shfmt,
}

null_ls.setup({ sources = sources })
