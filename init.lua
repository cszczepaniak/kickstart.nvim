-- Put opts first; subsequent things (mostly keymappings) will depend on
-- options being set (mostly the leader)
require("core.opts")
require("core.autocmds")
require("core.diag")
require("core.keymaps")
require("core.lsp")
require("plugins")
