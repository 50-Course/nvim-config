local _, null_ls = pcall(require, "null-ls")

local sources = {
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.prettierd.with({
	filetypes = { "html", "json", "yaml", "markdown", "css", "scss", "less", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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


local attach_to_lsp = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
        vim.cmd [[augroup END]]
    end
end

null_ls.setup({ debug = false, sources = sources, on_attach = attach_to_lsp})
