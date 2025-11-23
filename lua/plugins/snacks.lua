return {
	"folke/snacks.nvim",
	priority = 1000,
	opts = {
	},
	config = function()
		vim.keymap.set("n", "<leader>sf", function()
			Snacks.picker.smart()
		end, { desc = "[S]earch [F]iles" })

		vim.keymap.set("n", "<leader>sn", function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		vim.keymap.set("n", "<leader>sw", Snacks.picker.grep_word, { desc = "[S]earch [W]ord" })

		vim.keymap.set("n", "<leader>sg", function(opts)
			Snacks.picker.grep({})
		end, { desc = "[S]earch by [G]rep" })

		vim.keymap.set("n", "<leader>gg", function(opts)
			Snacks.lazygit.open()
		end, { desc = "[S]earch by [G]rep" })
	end,
}
