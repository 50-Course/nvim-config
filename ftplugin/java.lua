local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/"
local jdtls_pack_path = vim.fn.stdpath("data") .. "/mason/packages/"

local root_markers = { "gradlew", "pom.xml", ".git", "mvnw", "build.gradle" }

local root_dir = require("jdtls.setup").find_root(root_markers)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), "p:h:t")

local workspace_folder = os.getenv("HOME")
    .. "/.local/share/eclipse/"
    .. project_name

local debug_adapter_jar_path = vim.fn.glob(
    jdtls_pack_path
        .. "java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
)

local function get_lombok_path()
    print("Unable to find Lombok in path")
end

local OS_NAME = "linux"

local config = {
    flags = {
        debounce_text_changes = 80,
        allow_incremental_sync = true,
    },
    root_dir = root_dir,
    init_options = {
        bundles = debug_adapter_jar_path,
    },
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens java.base/java.util=ALL-UNNAMED",
        "--add-opens java.base/java.lang=ALL-UNNAMED",

        "-jar",
        jdtls_path .. "plugins/org.eclipse.equinox.launcher_*.jar",
        "-configuration",
        jdtls_path .. "config_" .. OS_NAME,
        -- Our dedicated JDTLS workspace
        "-data",
        workspace_folder,
    },
    settings = {
        java = {
            signatureHelp = { enabled = true },
            saveActions = {
                organizeImports = true,
            },
            format = {
                settings = {
                    url = "/.local/share/eclipse/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            contentProvider = { preferred = "fernflower" },
            completion = {
                maxResults = 25,
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                    "org.mockito.ArgumentMatchers.*",
                    "org.mockito.Answers.RETURNS_DEEP_STUBS",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = os.getenv("JAVA_HOME"),
                    },
                    {
                        name = "JavaSE-17",
                        path = vim.fn.glob("/usr/lib/jvm/jdk-17/bin")
                    },
                },
            },
        },
    },
}

-- Additional mappings

local java_buf_mappings = function (_, bufnr)
    local bufopts = { noremap = true, buffer = bufnr }
    vim.keymap.set(
        "n",
        "<leader>o",
        " <Cmd>lua require'jdtls'.organize_imports()<CR>",
        bufopts
    )
    vim.keymap.set(
        "n",
        "<leader>ev",
        " <Cmd>lua require('jdtls').extract_variable()<CR>",
        bufopts
    )
    vim.keymap.set(
        "v",
        "<leader>ev",
        " <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
        bufopts
    )
    vim.keymap.set(
        "n",
        "<leader>ec",
        " <Cmd>lua require('jdtls').extract_constant()<CR>",
        bufopts
    )
    vim.keymap.set(
        "v",
        "<leader>ec",
        " <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
        bufopts
    )
    vim.keymap.set(
        "v",
        "<leader>em",
        " <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
        bufopts
    )
end

local client = vim.lsp.get_client_by_id() == "java"

if vim.lsp.buf_is_attached(0, client) then
    local java_bindings = vim.api.nvim_create_augroup("JavaBindings", {
        clear = true
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = java_bindings,
        callback = java_buf_mappings
    })
end

-- For testing
-- vim.keymap.set("n", , , bufopts) <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
-- vim.keymap.set("n", , , bufopts) <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>

require("jdtls").start_or_attach(config)
