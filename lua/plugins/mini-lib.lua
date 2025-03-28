return {
	-- setup mini pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},
	-- setup mini icons
	{
		"echasnovski/mini.icons",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},
	-- setup mini surround
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "gza", -- Add surrounding in Normal and Visual modes
					delete = "gzd", -- Delete surrounding
					find = "gzf", -- Find surrounding (to the right)
					find_left = "gzF", -- Find surrounding (to the left)
					highlight = "gzh", -- Highlight surrounding
					replace = "gzr", -- Replace surrounding
					update_n_lines = "gzn", -- Update `n_lines`
				},
			})
		end,
	},
	-- setup mini ai
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	-- setup mini splitjoin
	{
		"echasnovski/mini.splitjoin",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.splitjoin").setup({
				mappings = {
					toggle = "sj",
					split = "",
					join = "",
				},
			})
		end,
	},
	-- auto root detection for project files
	{
		"echasnovski/mini.misc",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.misc").setup({})
			require("mini.misc").setup_auto_root({ ".git", "Makefile", "package.json" })
		end,
	},
	--setup mini move
	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.move").setup({})
		end,
	},
	-- setup mini indent
	{
		"echasnovski/mini.indentscope",
		event = "VeryLazy",
		version = false,
		config = function()
			-- if init function can't disable mini indentscope for snacks_dashboard. This is a workaround
			local current_filetype = vim.bo.filetype
			if
				vim.tbl_contains({
					"Trouble",
					"alpha",
					"dashboard",
					"snacks_dashboard",
					"fzf",
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"notify",
					"snacks_notif",
					"snacks_terminal",
					"snacks_win",
					"toggleterm",
					"trouble",
				}, current_filetype)
			then
				vim.b.miniindentscope_disable = true
			end

			require("mini.indentscope").setup()
		end,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"Trouble",
					"alpha",
					"dashboard",
					"snacks_dashboard",
					"fzf",
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"notify",
					"snacks_notif",
					"snacks_terminal",
					"snacks_win",
					"toggleterm",
					"trouble",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	{
		"echasnovski/mini.diff",
		version = false,
		event = "VeryLazy",
		config = function()
			require("mini.diff").setup({
				view = {
					style = "sign",
					signs = { add = "▎", change = "▎", delete = "▎" },
				},
			})
		end,
		keys = {
			{
				"<leader>td",
				"<cmd>lua MiniDiff.toggle_overlay()<cr>",
				desc = "Toggle Mini Diff Overlay",
			},
			{
				"<leader>to",
				"<cmd>lua MiniDiff.textobject()<cr>",
				desc = "Mini Diff Text Object",
			},
		},
	},

	{
		"echasnovski/mini.comment",
		version = false,
	},
}
