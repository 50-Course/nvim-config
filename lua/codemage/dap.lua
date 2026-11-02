--- Module to house all my debugging configurations
---
--- ...keybinds, individual plugin configurations, etc
local M = {}

local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup({})

--- utility function to setup DAP listeners for `dapui` open/close
function M.setup_event_listeners()
    dap.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

--- Check if a DAP is installed via Mason
-- local function is_dap_installed(dap_name)
--     return require("mason-registry").is_installed(dap_name)
-- end

--- Configure keymaps for debugging actions
function M.setup_dap_keymaps()
    local map = vim.keymap.set
    map(
        "n",
        "<localleader>db",
        dap.toggle_breakpoint,
        { desc = "Debug: [T]oggle breakpoint" }
    )
    map("n", "<localleader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: [S]et breakpoint ('conditional')" })
    map("n", "<localleader>dsn", dap.step_over, { desc = "Debug: Step [N]ext" })
    map("n", "<localleader>dsi", dap.step_into, { desc = "Debug: Step [I]nto" })
    map("n", "<localleader>dso", dap.step_out, { desc = "Debug: Step [O]ut" })
    map(
        "n",
        "<localleader>dc",
        dap.continue,
        { desc = "Debug: Start/[C]ontinue" }
    )
    map("n", "<localleader>dr", dap.repl.open, { desc = "Debug: [R]epl" })
    map("n", "<localleader>dlp", dap.run_last, { desc = "Debug: Run [L]ast" })
    map("n", "<localleader>dx", dap.terminate, { desc = "Debug: [T]erminate" })
end

return M
