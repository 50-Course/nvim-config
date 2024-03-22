-- Syntax highlighting and other language specific stuff.
--
-- nvim-treesitter supercharges syntax highlighting with better language support.
-- nvim-treesitter also improves the ability to navigate through code quickly.

local filetypes = {
    "c",
    "cpp",
    "go",
    "javascript",
    "lua",
    "markdown",
    "python",
    "rust",
    "java",
}

require("nvim-treesitter.configs").setup({
    ensure_installed = filetypes,

    sync_install = false,
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn", -- maps in normal mode to init the node/scope selection
            node_incremental = "grn", -- increment to the upper named parent
            scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
            node_decremental = "grm", -- decrement to the previous node
        },
    },
    -- Configuration for the nvim-treesitter-textobjects plugin
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = { ["<leader>s"] = "@parameter.inner" },
            swap_previous = { ["<leader>S"] = "@parameter.inner" },
        },
    },
})
