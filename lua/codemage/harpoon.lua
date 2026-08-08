-- ******************************** Harpoon ********************************
local harpoon = require("harpoon")
local opts = { noremap = true, silent = true }

--- Maps a key to a command in normal mode with the default options.
---
--- @param description string The description of the key mapping.
--- @param keybind string The key combination to map.
--- @param command function The command to execute when the key is pressed.
local function map(description, keybind, command)
    vim.keymap.set("n", keybind, command, vim.tbl_extend("force", opts, { desc = description }))
end

map("[h]arpoon [a]dd", "<localleader>ha", function()
    harpoon.mark.add_file()
end)

map("Open [h]arpoon [l]ist", "<localleader>hl", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map("[h]arpoon [n]ext", "<localleader>hn", function()
    harpoon:list():next()
end)

map("[h]arpoon [p]revious", "<localleader>hp", function()
    harpoon:list():prev()
end)
