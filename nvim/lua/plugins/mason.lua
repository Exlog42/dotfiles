return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	opts = {
		ensure_installed = {
			"ruff",
		},
	},
	config = true,
}
