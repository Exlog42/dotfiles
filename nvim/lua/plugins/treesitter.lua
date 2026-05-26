return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- 安装常用语言 parser
		require("nvim-treesitter").install({
			"go",
			"c",
			"cpp",
			"python",
			"lua",
			"bash",
			"json",
			"markdown",
			"markdown_inline",
			"yaml",
			"vim",
			"vimdoc",
			"query",
		})

		-- 对所有文件类型启用 treesitter 高亮
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
