local M = {}

---@class Options
---@field additional_args? string[]
---@field test_package? boolean

---@param opts Options
local run_tests = function(opts)
	local additional_args = {}
	if opts and opts.additional_args then
		additional_args = opts.additional_args
	end

	local test_package = (opts and opts.test_package) or false
	if test_package then
		vim.call("VimuxRunCommand", "go test ./" .. vim.fn.expand("%:h"))
		return
	end

	if vim.fn.executable("gotestlist") == 0 then
		local res = vim.system({ "go", "install", "github.com/cszczepaniak/gotestlist@latest" }):wait()
		if res.code ~= 0 then
			vim.notify("Error installing gotestlist: " .. res.stderr, vim.log.levels.ERROR)
			return
		end
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

	args = vim.list_extend(args, additional_args or {})

	-- Now add the target package path
	args = vim.list_extend(args, { "./" .. vim.fn.expand("%:h") })

	-- Run the test in a tmux window (nearest, or create a new one)
	vim.call("VimuxRunCommand", vim.fn.join(args, " "))
end

local prompt_for_args = function()
	local args = vim.fn.input("Additional args: ")
	return vim.split(args, " ")
end

M.setup = function()
	vim.keymap.set("n", "<leader>tp", function()
		run_tests({
			test_package = true,
		})
	end, { desc = "Go: [T]est [p]ackage" })

	vim.keymap.set("n", "<leader>tP", function()
		run_tests({
			test_package = true,
			additional_args = prompt_for_args(),
		})
	end, { desc = "Go: [T]est [p]ackage (with additional args)" })

	vim.keymap.set("n", "<leader>tn", run_tests, { desc = "Go: [T]est [n]earest" })
	vim.keymap.set("n", "<leader>tN", function()
		run_tests({
			additional_args = prompt_for_args(),
		})
	end, { desc = "Go: [T]est [n]earest (with additional args)" })
end

return M
