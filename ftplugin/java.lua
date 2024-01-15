local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/"

local root_markers = { "gradlew", "pom.xml", ".git", "mvnw", "build.gradle" }

local root_dir = require("jdtls.setup").find_root(root_markers)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), "p:h:t")

local workspace_folder = os.getenv("HOME")
    .. "/.local/share/eclipse/"
    .. project_name


local debug_adapter_jar_path = vim.fn.glob(
    jdtls_path .. '/mason/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
)


local config = {
    flags = {
        debounce_text_changes = 80,
        allow_incremental_sync = true,
    },
    root_dir = root_dir,
    init_options = {
	    bundles = debug_adapter_jar_path
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
			"jdk.*", "sun.*",
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
                        name = "JavaSE-17",
                        path = os.getenv("JAVA_HOME"),
                    },
                },
            },
        },
    },
}

-- Additional mappings
local bufopts = { noremap = true, buffer = bufnr}

vim.keymap.set(
    "n",
    "<localleader>o",
    " <Cmd>lua require'jdtls'.organize_imports()<CR>",
    bufopts
)
vim.keymap.set(
    "n",
    "<localleader>ev",
    " <Cmd>lua require('jdtls').extract_variable()<CR>",
    bufopts
)
vim.keymap.set(
    "v",
    "<localleader>ev",
    " <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    bufopts
)
vim.keymap.set(
    "n",
    "<localleader>ec",
    " <Cmd>lua require('jdtls').extract_constant()<CR>",
    bufopts
)
vim.keymap.set(
    "v",
    "<localleader>ec",
    " <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
    bufopts
)
vim.keymap.set(
    "v",
    "<localleader>em",
    " <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
    bufopts
)

-- For testing
-- vim.keymap.set("n", , , bufopts) <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
-- vim.keymap.set("n", , , bufopts) <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>


require("jdtls").start_or_attach(config)
