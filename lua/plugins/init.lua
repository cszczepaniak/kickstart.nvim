-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.autocomplete"),
	require("plugins.autoformat"),
	require("plugins.telescope"),
	require("plugins.lazygit"),
	require("plugins.lsp"),
	require("plugins.mini"),
	require("plugins.theme"),
	require("plugins.treesitter"),
	require("plugins.tmux"),
	-- vimux is needed by our custom plugins
	{
		"preservim/vimux",
		config = function()
			local function run_tests(opts)
				local additional_args = {}
				if opts and opts.additional_args then
					additional_args = vim.fn.split(opts.additional_args)
				end

				local r, c = unpack(vim.api.nvim_win_get_cursor(0))
				local cmd = { "gotestlist", "-file", vim.fn.expand("%"), "-pos", r .. "," .. c + 1 }
				local job = vim.system(cmd)
				local result = job:wait()
				local lines = vim.fn.split(result.stdout)

				local function startswith(s, start)
					return s:sub(1, #start) == start
				end

				local function testpat(s)
					return "^" .. s .. "$"
				end

				local function squote(s)
					return "'" .. s .. "'"
				end

				local args = { "go", "test" }

				if #lines == 0 then
					return nil
				elseif #lines > 1 then
					args = vim.list_extend(args, { "-run" })

					-- The test pattern is thus: '^TestA$|^TestB$'
					local pat = vim.fn.join(vim.tbl_map(testpat, lines), "|")
					pat = squote(pat)
					args = vim.list_extend(args, { pat })
				else
					-- Single test or benchmark, (pattern is '^TestA$')
					local pat = squote(testpat(lines[1]))
					if startswith(lines[1], "Test") then
						args = vim.list_extend(args, { "-run", pat })
					else
						args = vim.list_extend(args, { "-run", "^$", "-benchmem", "-bench", pat })
					end
				end

				args = vim.list_extend(args, additional_args)

				-- Now add the target package path
				args = vim.list_extend(args, { "./" .. vim.fn.expand("%:h") })

				-- Run the test in a tmux window (nearest, or create a new one)
				vim.call("VimuxRunCommand", vim.fn.join(args, " "))
			end

			vim.keymap.set("n", "<leader>tn", run_tests)
			vim.keymap.set("n", "<leader>tN", function()
				local args = vim.fn.input("Additional args: ")
				run_tests({
					additional_args = args,
				})
			end)
		end,
	},
})
