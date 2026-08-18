return {
	"lervag/vimtex",
	lazy = false, -- vimtex 必须在启动时加载，不能 lazy
	ft = { "tex", "bib" },
	init = function()
		-- PDF 查看器
		vim.g.vimtex_view_method = "general"
		vim.g.vimtex_view_general_viewer = "okular"
		vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"

		-- 编译器
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = "",
			out_dir = "",
			callback = 1,
			continuous = 0, -- 0 = 手动编译，1 = 保存时自动编译
			executable = "latexmk",
			options = {
				"-pdf",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-shell-escape",
			},
		}

		-- 关闭 vimtex 自带的 warnings（texlab LSP 已覆盖诊断）
		vim.g.vimtex_quickfix_mode = 0

		-- 隐藏一些冗余警告
		vim.g.vimtex_log_ignore = {
			"Underfull",
			"Overfull",
			"specifier changed to",
			"Token not allowed in a PDF string",
		}

		-- 不使用 vimtex 的 fold（性能）
		vim.g.vimtex_fold_enabled = 0

		-- 关闭 imaps（与 LuaSnip 冲突）
		vim.g.vimtex_imaps_enabled = 0

		-- 打开 tex 文件时启动固定路径的 socket，供 Okular 反向搜索使用
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex",
			once = true,
			callback = function()
				local socket = "/tmp/nvim_latex.sock"
				vim.fn.delete(socket) -- 删除上次遗留的 socket
				vim.fn.serverstart(socket)
			end,
		})
	end,
}
