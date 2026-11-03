-- Nvim java uses a fork of Mason registry so we ahve to setup the two
--
local registries = {
    "github:nvim-java/mason-registry",
    "github:mason-org/mason-registry",
}

-- setup mason
require("mason").setup({
    registries = registries,
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

local function get_java_home()
    local java_home = vim.env.JAVA_HOME

    -- if present return it
    if java_home and vim.fn.executable(java_home .. "/bin/java") == 1 then
        return vim.fn.resolve(java_home)
    end

    -- otherwise, use sdkman's current java installation
    local sdkman_dir = vim.env.SDKMAN_DIR or (vim.env.HOME .. "/.sdkman")
    local sdkman_java = sdkman_dir .. "/candidates/java/current"

    if vim.fn.executable(sdkman_java .. "/bin/java") == 1 then
        return vim.fn.resolve(sdkman_java)
    end

    -- fallback to available java on the system
    local java = vim.fn.exepath("java")

    if java ~= "" then
        return vim.fn.fnamemodify(vim.fn.resolve(java), ":h:h")
    end

    -- otherwise return nothing
    return nil
end

local java_home = get_java_home()

if not java_home then
    vim.notify(
        "No JDK found. Install Java or configure JAVA_HOME.",
        vim.log.levels.WARN
    )
else
    require("java").setup({
        jdk = {
            auto_install = false,
            path = java_home,
        },
    })
    vim.lsp.enable('jdtls')
end
-- require("lspconfig").jdtls.setup({})
