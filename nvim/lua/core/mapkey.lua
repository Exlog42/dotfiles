vim.g.mapleader = " "
vim.keymap.set("n", "<leader>m", "<cmd>Outline<CR>")
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>R", "<cmd>source $MYVIMRC<CR>", { desc = "重载 core 配置" })
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- 新建文件（自动创建父目录）
vim.keymap.set("n", "<leader>n", function()
	local path = vim.fn.input("新建文件: ", vim.fn.getcwd() .. "/", "file")
	if path ~= "" then
		vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
		vim.cmd("edit " .. path)
	end
end, { desc = "新建文件" })

-- 关闭当前 buffer（保留窗口布局）
vim.keymap.set("n", "<leader>q", "<C-w>c", { desc = "关闭当前窗口" })

-- 切回上一个 buffer
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "切回上一个文件" })

-- 分屏
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "垂直分屏" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "水平分屏" })

-- tab switch
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, ":tabn " .. i .. "<CR>", { desc = "切换到第 " .. i .. " 个 Tab" })
end

-- 在最右侧打开标签页
vim.keymap.set("n", "<leader>nt", function()
	vim.cmd("tablast | tabnew")
end, { desc = "Open a new tab at the end" })

-- 关闭当前标签页
vim.keymap.set("n", "<leader>ct", function()
	vim.cmd("tabclose")
end, { desc = "Close current tab" })
