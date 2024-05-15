local import_status, flutter_tools = pcall(require, "flutter-tools")

if not import_status then
    error("Error loading flutter_tools.lua\n" .. flutter_tools)
end

flutter_tools.setup({
    fvm = true,
    debugger = {
        enabled = true,
    },
})
