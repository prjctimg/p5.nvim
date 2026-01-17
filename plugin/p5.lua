if vim.fn.has("nvim-0.11.0") == 0 then
	vim.notify("p5.nvim requires Neovim >= 0.11.0", vim.log.levels.WARN)
	return
else
	require("p5")
end
