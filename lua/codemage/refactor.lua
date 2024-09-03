local import_status_ok, refactoring = pcall(require, "refactoring")

if not import_status_ok then
    return
end

vim.keymap.set("x", "<localleader>re", function()
    require("refactoring").refactor("Extract Function")
end)
vim.keymap.set("x", "<localleader>rf", function()
    require("refactoring").refactor("Extract Function To File")
end)
-- Extract function supports only visual mode
vim.keymap.set("x", "<localleader>rv", function()
    require("refactoring").refactor("Extract Variable")
end)
-- Extract variable supports only visual mode
vim.keymap.set("n", "<localleader>rI", function()
    require("refactoring").refactor("Inline Function")
end)
-- Inline func supports only normal
vim.keymap.set({ "n", "x" }, "<localleader>ri", function()
    require("refactoring").refactor("Inline Variable")
end)
-- Inline var supports both normal and visual mode

vim.keymap.set("n", "<localleader>rb", function()
    require("refactoring").refactor("Extract Block")
end)
vim.keymap.set("n", "<localleader>rbf", function()
    require("refactoring").refactor("Extract Block To File")
end)
-- Extract block supports only normal mode

-- prompt for a refactor to apply when the remap is triggered
vim.keymap.set({ "n", "x" }, "<localleader>rr", function()
    require("refactoring").select_refactor()
end)

refactoring.setup({
    prompt_return_type = {
        java = true,
        go = true,
    },
    prompt_func_param_type = {
        java = true,
        go = true,
    },
})
