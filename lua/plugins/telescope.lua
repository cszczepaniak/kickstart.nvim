return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{ "mrloop/telescope-git-branch.nvim" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "git_branch")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.git_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })

		vim.keymap.set("n", "<leader>sg", function(opts)
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local conf = require("telescope.config").values

			opts = opts or {}
			opts.cwd = opts.cwd or vim.uv.cwd()

			local finder = finders.new_async_job({
				command_generator = function(prompt)
					if not prompt or prompt == "" then
						return nil
					end

					local pieces = vim.split(prompt, "  ")
					local args = { "rg" }
					if pieces[1] then
						table.insert(args, "-e")
						table.insert(args, pieces[1])
					end

					if pieces[2] then
						table.insert(args, "-g")
						table.insert(args, pieces[2])
					end

					---@diagnostic disable-next-line: deprecated
					return vim.tbl_flatten({
						args,
						{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
					})
				end,
				make_entry = make_entry.gen_from_vimgrep(opts),
				cwd = opts.cwd,
			})

			pickers
				.new(opts, {
					debounce = 100,
					prompt_title = "Multi Grep",
					finder = finder,
					previewer = conf.grep_previewer(opts),
					sorter = require("telescope.sorters").empty(),
				})
				:find()
		end, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", function()
			require("git_branch").files()
		end, { desc = "[S]earch for [D]iffed files" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
