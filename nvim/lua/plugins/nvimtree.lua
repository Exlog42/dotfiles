return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		view = {
			width = 30,
		},
		sort_by = "case_sensitive",
		renderer = {
			group_empty = false,
			icons = {
				git_placement = "after",
			},
		},
		filters = {
			dotfiles = false,
			git_clean = false,
		},
		reload_on_bufenter = true,
		hijack_cursor = false,
		update_focused_file = {
			enable = true,
			update_root = false
		},
		git = {
			ignore = false,
		},
		sync_root_with_cwd = true,
		-- 禁用git根目录检测
		prefer_startup_root = false
		-- respect_buf_cwd = true,
		-- update_cwd = true,
	},
}
