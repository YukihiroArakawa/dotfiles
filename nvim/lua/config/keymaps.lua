-- 現在のファイルのフルパスをクリップボードにヤンクする
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p")
	-- システムのクリップボードを表す '+' レジスタを使用
	vim.fn.setreg("+", path)
	vim.notify("Copied path to clipboard: " .. path)
end, { desc = "Copy file path to clipboard" })
