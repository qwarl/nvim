local is_path = require("util")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		cmd = { "TSUpdate", "TSInstall" },
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install({
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
				"json5",
				"latex",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"nix",
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
			})

			-- Enable treesitter highlighting, indents and folds
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ok = pcall(vim.treesitter.start)
					if ok then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo.foldlevel = 99
					end
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		enabled = false,
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
			require("treesitter-context").setup({})
			vim.keymap.set("n", "<leader>tc", "<cmd>TSContextToggle toggle<CR>", { desc = "Toggle Treesitter Context" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- enabled = false,
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		init = function()
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
					},

					include_surrounding_whitespace = false,
				},
			})

			-- Text Objects: Selection
			-- Selection: @function.outer (around function)
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Select around function" })
			-- Selection: @function.inner (inside function)
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inside function" })
			-- Selection: @class.outer (around class/struct)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Select around class" })
			-- Selection: @class.inner (inside class/struct)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inside class" })
			-- Selection: @local.scope (around current scope/block)
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end, { desc = "Select around scope" })

			-- Swapping parameters
			-- Swap current parameter with next one
			vim.keymap.set("n", "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap next parameter" })
			-- Swap current parameter with previous one
			vim.keymap.set("n", "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end, { desc = "Swap previous parameter" })

			-- Navigation: Jumps
			-- Jump to next function start
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			-- Jump to next class start
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			-- Jump to next loop (for/while)
			vim.keymap.set({ "n", "x", "o" }, "]o", function()
				require("nvim-treesitter-textobjects.move").goto_next_start(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end, { desc = "Next loop" })
			-- Jump to next local scope
			vim.keymap.set({ "n", "x", "o" }, "]s", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
			end, { desc = "Next local scope" })
			-- Jump to next fold
			vim.keymap.set({ "n", "x", "o" }, "]z", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
			end, { desc = "Next fold" })

			-- Jump to next function end
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			-- Jump to next class end
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })

			-- Jump to previous function start
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			-- Jump to previous class start
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class start" })

			-- Jump to previous function end
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Prev function end" })
			-- Jump to previous class end
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Prev class end" })

			-- Jump to next/prev conditional (if/else)
			vim.keymap.set({ "n", "x", "o" }, "]l", function()
				require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
			end, { desc = "Next conditional" })
			vim.keymap.set({ "n", "x", "o" }, "[l", function()
				require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
			end, { desc = "Prev conditional" })

			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
}
