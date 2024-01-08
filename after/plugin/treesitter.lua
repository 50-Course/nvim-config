-- Syntax highlighting and other language specific stuff.
--
-- nvim-treesitter supercharges syntax highlighting with better language support.
-- nvim-treesitter also improves the ability to navigate through code quickly.
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "cpp",
        "go",
        "javascript",
        "lua",
        "markdown",
        "python",
        "rust",
        "java",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
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
