return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup()
		local terminal = require("toggleterm.terminal").Terminal
		local lazygit = terminal:new({ direction = "float", cmd = "lazygit", hidden = true })

		vim.keymap.set("n", "<leader>gg", function()
			lazygit:toggle()
		end)
	end,
}
