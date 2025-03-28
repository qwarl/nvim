local is_path = require("util")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"csv",
				"css",
				"diff",
				"git_config",
				"html",
				"http",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"latex",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"rust",
				"toml",
				"tsx",
				"tsv",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
			},
			autotag = { enable = false },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-\\>",
					node_incremental = "<C-\\>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			local function add(lang)
				if type(opts.ensure_installed) == "table" then
					table.insert(opts.ensure_installed, lang)
				end
			end

			vim.filetype.add({
				extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
				filename = {
					["vifmrc"] = "vim",
				},
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "bash",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})

			if is_path.exists_in_config("hypr") then
				add("hyprlang")
			end

			if is_path.exists_in_config("fish") then
				add("fish")
			end

			if is_path.exists_in_config("rofi") or is_path.exists_in_config("wofi") then
				add("rasi")
			end

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = false,
			})
			vim.keymap.set("n", "<leader>tc", "<cmd>TSContextToggle<CR>", { desc = "Toggle Treesitter Context" })
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	config = function()
	-- 		require("nvim-treesitter.configs").setup({
	-- 			textobjects = {
	-- 				select = {
	-- 					enable = true,
	-- 					keymaps = {
	-- 						["af"] = { query = "@function.outer", desc = "Select outer part of a function call" },
	-- 						["if"] = { query = "@function.inner", desc = "Select inner part of a function call" },
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
	--
	-- 		-- vim way: ; goes to the direction you were moving.
	-- 		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
	-- 		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
	--
	-- 		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
	-- 		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
	-- 		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
	-- 		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
	-- 		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
	-- 	end,
	-- },

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
    -- enabled = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					-- Select text objects
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = { query = "@function.outer", desc = "Select around function" },
							["if"] = { query = "@function.inner", desc = "Select inside function" },
							["ac"] = { query = "@class.outer", desc = "Select around class" },
							["ic"] = { query = "@class.inner", desc = "Select inside class" },
							["aa"] = { query = "@parameter.outer", desc = "Select around parameter" },
							["ia"] = { query = "@parameter.inner", desc = "Select inside parameter" },
							["ab"] = { query = "@block.outer", desc = "Select around block" },
							["ib"] = { query = "@block.inner", desc = "Select inside block" },
							["al"] = { query = "@loop.outer", desc = "Select around loop" },
							["il"] = { query = "@loop.inner", desc = "Select inside loop" },
							["as"] = { query = "@statement.outer", desc = "Select around statement" },
							["is"] = { query = "@statement.inner", desc = "Select inside statement" },
							["aC"] = { query = "@call.outer", desc = "Select around function call" },
							["iC"] = { query = "@call.inner", desc = "Select inside function call" },
						},
						include_surrounding_whitespace = false,
					},

					-- Move between text objects
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = { query = "@function.outer", desc = "Next function start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
							["]b"] = { query = "@block.outer", desc = "Next block start" },
							["]l"] = { query = "@loop.outer", desc = "Next loop start" },
							["]s"] = { query = "@statement.outer", desc = "Next statement start" },
							["]k"] = { query = "@call.outer", desc = "Next call start" },
						},
						goto_next_end = {
							["]F"] = { query = "@function.outer", desc = "Next function end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
							["]B"] = { query = "@block.outer", desc = "Next block end" },
							["]L"] = { query = "@loop.outer", desc = "Next loop end" },
							["]S"] = { query = "@statement.outer", desc = "Next statement end" },
							["]K"] = { query = "@call.outer", desc = "Next call end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@function.outer", desc = "Previous function start" },
							["[c"] = { query = "@class.outer", desc = "Previous class start" },
							["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
							["[b"] = { query = "@block.outer", desc = "Previous block start" },
							["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
							["[s"] = { query = "@statement.outer", desc = "Previous statement start" },
							["[k"] = { query = "@call.outer", desc = "Previous call start" },
						},
						goto_previous_end = {
							["[F"] = { query = "@function.outer", desc = "Previous function end" },
							["[C"] = { query = "@class.outer", desc = "Previous class end" },
							["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
							["[B"] = { query = "@block.outer", desc = "Previous block end" },
							["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
							["[S"] = { query = "@statement.outer", desc = "Previous statement end" },
							["[]K"] = { query = "@call.outer", desc = "Previous call end" },
						},
					},

					-- Swap text objects
					swap = {
						enable = true,
						swap_next = {
							["<leader>snp"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
							["<leader>sf"] = { query = "@function.outer", desc = "Swap with next function" },
						},
						swap_previous = {
							["<leader>spp"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
							["<leader>sF"] = { query = "@function.outer", desc = "Swap with previous function" },
						},
					},

					-- Peek definition (LSP integration)
					lsp_interop = {
						enable = true,
						border = "single",
						peek_definition_code = {
							["<leader>df"] = { query = "@function.outer", desc = "Peek function definition" },
							["<leader>dc"] = { query = "@class.outer", desc = "Peek class definition" },
						},
					},
				},
			})
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- vim way: ; goes to the direction you were moving.
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
		end,
	},
}
