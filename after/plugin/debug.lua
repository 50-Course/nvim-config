--- Module to house all my debugging configurations
---
--- ...keybinds, individual plugin configurations, etc
---
local M = {}

local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()

local function setup_elixir_adapter()
    -- dap.adapters.elixir = {
    --     {
    --         name = "Run Debugger",
    --         request = "attach",
    --         type = "elixir-ls-debugger",
    --     },
    -- }

    dap.adapters.elixir = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
            command = "elixir-ls",
            args = {
                "--enable-debug-adapter",
                "--stdio",
            },
        },
    }
end

local function setup_elixir_configurations() 
    dap.configurations.elixir = {
        {
            type = "elixir",
            name = "mix test",
            request = "launch",
            task = "test",
            taskArgs = { "--trace" },
            startApps = true,
            projectDir = "${workspaceFolder}",
            requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
        },
        {
            type = "elixir",
            name = "mix test (single file)",
            request = "launch",
            task = "test",
            taskArgs = function()
                local testFile = vim.fn.input("Test file: ", "test/", "file")
                return { testFile }
            end,
            startApps = true,
            projectDir = "${workspaceFolder}",
            requireFiles = { "test/**/test_helper.exs" },
        },
        {
            type = "elixir",
            name = "phx.server",
            request = "launch",
            task = "phx.server",
            projectDir = "${workspaceFolder}",
            debugAutoInterpretAllModules = false,
            debugInterpretModulesPatterns = { "MyApp*", "MyAppWeb*" },
            exitAfterTaskReturns = false,
        },
        {
            type = "elixir",
            name = "mix run",
            request = "launch",
            task = "run",
            projectDir = "${workspaceFolder}",
            program = function()
                return vim.fn.input("File to run: ", "", "file")
            end,
        },
        {
            type = "elixir",
            name = "Launch Current File",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }
end

-- TODO: comeback to this later
--
-- configure the adapters for elixir
function M.setup_elixir()
    setup_elixir_adapter()
    setup_elixir_configurations()
end

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

-- configures for adapters for Go
function M.setup_go()
    dap.adapters.delve = function(callback, config)
        if config.mode == "remote" and config.request == "attach" then
            callback({
                type = "server",
                host = config.host or "127.0.0.1",
                port = config.port or "38697",
            })
        else
            callback({
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = {
                        "dap",
                        "-l",
                        "127.0.0.1:${port}",
                        "--log",
                        "--log-output=dap",
                    },
                    detached = vim.fn.has("win32") == 0,
                },
            })
        end
    end

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
        {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}",
        },
        {
            type = "delve",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}",
        },
        -- works with go.mod packages and sub packages
        {
            type = "delve",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
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
end

local function setup_debuggers()
    M.setup_python()
    M.setup_java()
    M.setup_dotnet()
    M.setup_js()
    M.setup_go()
    M.setup_elixir()
end

local function setup_dap_keymaps()
    local map = vim.keymap.set

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

    map("n", "<localleader>dr", dap.repl.open, { desc = "Debug: Open [R]epl" })
    map("n", "<localleader>lp", dap.run_last, { desc = "Debug: Run [L]ast" })
    map("n", "<localleader>dx", dap.terminate, { desc = "Debug: [XT]erminate" })
end

function M.setup()
    setup_event_handlers()
    setup_debuggers()
    setup_dap_keymaps()

    dapui.setup()
end

M.setup()

return M
