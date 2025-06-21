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
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = true,
				ensure_installed = {},
				ignore_install = {},
				auto_install = true,
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["at"] = "@class.outer",
							["it"] = "@class.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aF"] = "@call.outer",
							["iF"] = "@call.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>fa"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>fA"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
