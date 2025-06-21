-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({})
			vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
			vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
			vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
			vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup()
			local terminal = require("toggleterm.terminal").Terminal
			local lazygit = terminal:new({ direction = "float", cmd = "lazygit", hidden = true })

			vim.api.nvim_create_user_command("LazyGitToggle", function()
				lazygit:toggle()
			end, {})
			vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>LazyGitToggle<CR>", { noremap = true, silent = true })
		end,
	},
}
