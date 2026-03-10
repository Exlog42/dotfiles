return {
	"hedyhli/outline.nvim",
	config = function()
		require("outline").setup({
			symbol_folding = {
				-- 折叠深度：超过 1 的层级（比如函数内部）会被自动折叠
				autofold_depth = 1,
				auto_unfold = {
					-- 关闭 hover 时自动展开子节点
					hovered = false,
					-- 保持当 root 只有 1 个节点时会自动展开（按需调整）
					only = true,
				},
				markers = { "", "" },
			},
		})
	end,
}
