return {
	"noir4y/comment-translate.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	enabled = false,
	opts = {
		target_language = "zh",
		translate_service = "llm",
		keymaps = {
			hover = "<S-Y>",
		},
		llm = {
			provider = "openai",
			model = "deepseek-v4-flash",
			api_key = vim.env.DEEPSEEK_API_KEY,
			endpoint = "https://api.deepseek.com/v1/chat/completions",
		},
	},
}
