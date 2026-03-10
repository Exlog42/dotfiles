return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		toggler = {
			line = "<C-/>",
		},
		---LHS of operator-pending mappings in NORMAL and VISUAL mode
		opleader = {
			line = "<C-/>",
		},
	},
}
