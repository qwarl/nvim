local check = require("util")

return {
	"lambdalisue/vim-suda",
	enabled = not check.is_win(),
}
