local M = {}

local dap, dapui = require("dap"), require("dapui")

local function setup_adapters()
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
    }

    dap.adapters.go = {
        type = "executable",
        command = "go delve",
    }
end

local function setup_event_handlers()
    dap.listeners.before.attach.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
    end
end

local function setup_debuggers()
    -- TODO: Write the debuggers configuratios later
    print("successfully setup debuggers")
end

local function setup_debugger_keymaps()
    local map = vim.keymap.set

    -- TODO: Write the keymaps later
end

function M.setup()
    setup_adapters()
    setup_event_handlers()
    setup_debuggers()
    setup_debugger_keymaps()

    dap.setup()
end

return M
