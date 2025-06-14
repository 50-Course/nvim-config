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

--print("Loaded custom Mason config!")

-- setup nvim java and lspconfig
--require("java").setup()
require("lspconfig").jdtls.setup({})
