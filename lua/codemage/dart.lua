local on_attach = require("codemage.lsp").on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Suppress "textChange/didChange" warning
local show_message = vim.lsp.handlers["window/showMessage"]

vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client and client.name == "dartls" then
        if
            result.type == vim.lsp.protocol.MessageType.Error
            and result.message:match("textDocument/didChange")
        then
            return
        end
    end
    return show_message(err, result, ctx, config)
end

require("flutter-tools").setup({
    debugger = {
        enabled = true,
        exception_breakpoints = {},
        evaluate_to_string_in_debug_views = true,
    },
    widget_guides = { enabled = true },
    lsp = {
        on_attach = on_attach,
        capabilities = capabilities,
    },
})
