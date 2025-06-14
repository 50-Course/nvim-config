--- Module to define all configurations regarding DiffView
local M = {}

local diffview = require("diffview")

--- Keybinds for vimdiff navigation
function M.setup_vimdiff_keymaps()
    --     So from the documentation, yeah, we can do:
    --     Additionally there are mappings for operating directly on the conflict
    -- markers:
    --   • `<leader>co`: Choose the OURS version of the conflict.
    --   • `<leader>ct`: Choose the THEIRS version of the conflict.
    --   • `<leader>cb`: Choose the BASE version of the conflict.
    --   • `<leader>ca`: Choose all versions of the conflict (effectively
    --     just deletes the markers, leaving all the content).
    --   • `dx`: Choose none of the versions of the conflict (delete the
    --     conflict region).

    local map = vim.keymap.set
    map(
        "n",
        "<localleader>vd",
        ":diffget //3<CR>",
        { desc = "Get changes from [3]" }
    )
    map(
        "n",
        "<localleader>vD",
        ":diffget //2<CR>",
        { desc = "Get changes from [2]" }
    )
    map(
        "n",
        "<localleader>v<",
        ":diffsplit<CR>",
        { desc = "Split diff [L]eft" }
    )
    map(
        "n",
        "<localleader>v>",
        ":diffsplit<CR>",
        { desc = "Split diff [R]ight" }
    )
    map(
        "n",
        "<localleader>vo",
        ":DiffviewOpen<CR>",
        { desc = "Diffview: [O]pen main diff" }
    )
    map(
        "n",
        "<localleader>vO",
        ":DiffviewFileHistory<CR>",
        { desc = "Diffview: File [O]pen History" }
    )
    map(
        "n",
        "<localleader>v=",
        ":DiffViewRefresh<CR>",
        { desc = "Re-sync diff updates" }
    )
    map(
        "n",
        "<localleader>vt",
        ":DiffviewToggleFiles<CR>",
        { desc = "Diffview: [T]oggle files panel" }
    )
    map("n", "<localleader>vn", "]c", { desc = "[N]ext diff" })
    map("n", "<localleader>vp", "[c", { desc = "[P]revious diff" })
    map(
        "n",
        "<localleader>vq",
        ":DiffviewClose<CR>",
        { desc = "[Q]uit diff view" }
    )
end

function M.setup()
    diffview.setup({
        use_icons = false,
    })
    M.setup_vimdiff_keymaps()
end

M.setup()

return M
