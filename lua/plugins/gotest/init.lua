return {
	{
		dir = vim.fn.stdpath("config") .. "/lua/plugins/gotest",
		dependencies = {
			"preservim/vimux",
		},
		config = function()
			require("gotest").setup()
		end,
	},
}
