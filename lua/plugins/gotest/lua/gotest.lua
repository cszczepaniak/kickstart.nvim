local M = {}

local run_tests = function(opts)
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

M.setup = function()
	vim.keymap.set("n", "<leader>tn", run_tests, { desc = "Go: [T]est [n]earest" })
	vim.keymap.set("n", "<leader>tN", function()
		local args = vim.fn.input("Additional args: ")
		run_tests({
			additional_args = args,
		})
	end, { desc = "Go: [T]est [n]earest (with additional args)" })
end

return M
