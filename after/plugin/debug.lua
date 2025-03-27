--- Module to house all my debugging configurations
---
--- ...keybinds, individual plugin configurations, etc
---
local M = {}

local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()

--- configures the adapters for python
function M.setup_python()
    dap.configurations.python = {
        {
            name = "Launch file",
            type = "python",
            request = "launch",
            program = "${file}",
        },
        {
            name = "Attach to process",
            type = "python",
            request = "attach",
            processId = "${command:pickProcess}",
        },
    }
end

--- configure the adapters for Java debugging
function M.setup_java()
    dap.configurations.java = {
        {
            name = "Launch Java",
            type = "java",
            request = "launch",
            -- mainClass = "${file}",
            mainClass = function()
                return vim.fn.input("Main class: ")
            end,
        },
    }
end

--- Configurations for C# debugging
function M.setup_dotnet()
    dap.configurations.netcoredbg = {
        {
            name = "Launch .NET Core",
            type = "netcoredbg",
            request = "launch",
            program = "${workspaceFolder}/bin/Debug/netcoreapp3.1/${workspaceFolderBasename}.dll",
            -- program = "${workspaceFolder}/bin/Debug/netcoreapp3.1/${workspaceFolderBasename}.dll",
        },
    }
end

--- configure the adapters for JavaScript/Node.js debugging
function M.setup_js()
    dap.configurations.javascript = {
        {
            name = "Launch Node",
            type = "node",
            request = "launch",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
        {
            name = "Attach to Process",
            type = "node",
            request = "attach",
            processId = require("dap.utils").pick_process,
        },
    }
end

--- Setup the low level configurations for the debugger
---
--- This one would configure our C/C++ debugger and as wwell Rust
function M.setup_low_level() end

-- local function setup_adapters()
--     dap.adapters.gdb = {
--         type = "executable",
--         command = "gdb",
--     }
--
--     dap.adapters.go = {
--         type = "executable",
--         command = "go delve",
--     }
-- end

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

    vim.notify("Successfully setup event handlers", vim.log.levels.INFO)
end

local function setup_debuggers()
    M.setup_python()
    M.setup_java()
    M.setup_dotnet()
    M.setup_js()
    -- print("successfully setup debuggers")
    vim.notify("Successfully setup debuggers", vim.log.levels.INFO)
end

local function setup_dap_keymaps()
    local map = vim.keymap.set

    -- toggler debugger

    -- toggle breakpoints
    map(
        "n",
        "<localleader>b",
        dap.toggle_breakpoint,
        { desc = "Debug: [T]oggle breakpoint" }
    )

    map("n", "<localleader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: [S]et breakpoint ('conditional')" })

    -- Steppers
    -- step over, step into, step out
    map("n", "<localleader>sn", dap.step_over, { desc = "Debug: Step [N]ext" })
    map("n", "<localleader>si", dap.step_into, { desc = "Debug: Step [I]nto" })
    map("n", "<localleader>so", dap.step_out, { desc = "Debug: Step [O]ut" })

    -- continue
    map(
        "n",
        "<localleader>cd",
        dap.continue,
        { desc = "Debug: Start/[C]ontinue" }
    )

    vim.notify("Keybinds configured successfully for DAP", vim.log.levels.INFO)
end

function M.setup()
    setup_event_handlers()
    setup_debuggers()
    setup_dap_keymaps()
end

M.setup()

return M
