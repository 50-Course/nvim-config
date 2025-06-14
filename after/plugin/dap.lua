--- Module to house all my debugging configurations
---
--- ...keybinds, individual plugin configurations, etc
local M = {}

local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()

--- utility function to setup DAP listeners for `dapui`
--- open/close
local function setup_event_listeners()
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

--- Check if a DAP is installed via Mason
local function is_dap_installed(dap_name)
    return require("mason-registry").is_installed(dap_name)
end

--- Utility function for common adapter setup with `port` and `command`
local function setup_generic_adapter(type, command, args)
    return {
        type = type,
        executable = {
            command = command,
            args = args or {},
        },
    }
end

--- Configures the Elixir DAP (via Elixir LS)
function M.setup_elixir()
    if not is_dap_installed("elixir-ls") then
        print("Elixir LS not installed via Mason")
        return
    end

    dap.adapters.elixir = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
            command = "elixir-ls",
            args = { "--enable-debug-adapter", "--stdio" },
        },
    }

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
                return { vim.fn.input("Test file: ", "test/", "file") }
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

--- Configures the Java adapter
function M.setup_java()
    if not is_dap_installed() then
        vim.notify(
            "Java Debug Adapter not installed via Mason.",
            vim.log.levels.WARN,
            { title = "DAP Setup" }
        )
        return
    end

    dap.configurations.java = {
        {
            name = "Launch Java",
            type = "java",
            request = "launch",
            mainClass = function()
                return vim.fn.input("Main class: ")
            end,
        },
    }
end

--- Configures the .NET Core adapter
function M.setup_dotnet()
    if not is_dap_installed() then
        vim.notify(
            ".NET Core Debugger not installed via Mason.",
            vim.log.levels.WARN,
            { title = "DAP Setup" }
        )
        return
    end

    dap.configurations.netcoredbg = {
        {
            name = "Launch .NET Core",
            type = "netcoredbg",
            request = "launch",
            program = "${workspaceFolder}/bin/Debug/netcoreapp3.1/${workspaceFolderBasename}.dll",
        },
    }
end

--- Configures the Python DAP (via `debugpy`)
function M.setup_python()
    if not is_dap_installed("debugpy") then
        print("Debugpy not installed via Mason")
        return
    end

    dap.adapters.python = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
            command = "debugpy",
            args = { "--listen", "127.0.0.1:${port}", "--wait-for-client" },
        },
    }

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

--- Configures the Go DAP (via `delve`)
function M.setup_go()
    if not is_dap_installed("delve") then
        print("Delve not installed via Mason")
        return
    end

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

    dap.configurations.go = {
        {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}",
        },
        {
            type = "delve",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${file}",
        },
        {
            type = "delve",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
        },
    }
end

--- Configures the JavaScript/Node.js DAP (via `pwa-node`)
function M.setup_js()
    if not is_dap_installed("js-debug-adapter") then
        vim.notify(
            "PWA Node not installed via Mason.",
            vim.log.levels.WARN,
            { title = "DAP Setup" }
        )
        return
    end

    local js_languages = {
        "vue",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
    }

    for _, language in ipairs(js_languages) do
        dap.configurations[language] = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pickProcess,
                cwd = "${workspaceFolder}",
                sourceMaps = true,
            },
            {
                type = "pwa-web",
                request = "Launch",
                name = "Debug and Launch Chrome",
                url = function()
                    local co = coroutine.running()
                    return coroutine.create(function()
                        vim.ui.input({
                            prompt = "Enter URL: ",
                            default = "http://localhost:3000",
                        }, function(url)
                            if url and url ~= "" then
                                coroutine.resume(co, url)
                            end
                        end)
                    end)
                end,
                webRoot = "${workspaceFolder}",
                protocol = "inspector",
                skipFiles = { "<node_internals>/* */*.js" },
                sourceMaps = true,
                userDataDir = false,
            },
        }
    end
end

--- Configure keymaps for debugging actions
function M.setup_dap_keymaps()
    local map = vim.keymap.set
    map(
        "n",
        "<localleader>b",
        dap.toggle_breakpoint,
        { desc = "Debug: [T]oggle breakpoint" }
    )
    map("n", "<localleader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: [S]et breakpoint ('conditional')" })
    map("n", "<localleader>sn", dap.step_over, { desc = "Debug: Step [N]ext" })
    map("n", "<localleader>si", dap.step_into, { desc = "Debug: Step [I]nto" })
    map("n", "<localleader>so", dap.step_out, { desc = "Debug: Step [O]ut" })
    map(
        "n",
        "<localleader>dc",
        dap.continue,
        { desc = "Debug: Start/[C]ontinue" }
    )
    map("n", "<localleader>dr", dap.repl.open, { desc = "Debug: Open [R]epl" })
    map("n", "<localleader>lp", dap.run_last, { desc = "Debug: Run [L]ast" })
    map("n", "<localleader>dx", dap.terminate, { desc = "Debug: [XT]erminate" })
end

--- Setup all debugger configurations
function M.setup_debuggers()
    M.setup_python()
    M.setup_java()
    M.setup_dotnet()
    M.setup_js()
    M.setup_go()
    M.setup_elixir()
end

--- Main setup function
function M.setup()
    setup_event_listeners()
    M.setup_debuggers()
    M.setup_dap_keymaps()

    dapui.setup()
end

M.setup()

return M
