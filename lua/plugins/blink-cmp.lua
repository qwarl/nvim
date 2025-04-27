return {
	{
		"t3ntxcl3s/ecolog.nvim",
		keys = {
			{ '<leader>el', '<Cmd>EcologShelterLinePeek<cr>', desc = 'Ecolog peek line' },
      { '<leader>eh', '<Cmd>EcologShellToggle<cr>', desc = 'Toggle shell variables' },
      { '<leader>ei', '<Cmd>EcologInterpolationToggle<cr>', desc = 'Toggle shell variables' },
      { '<leader>ge', '<cmd>EcologGoto<cr>', desc = 'Go to env file' },
      { '<leader>ec', '<cmd>EcologSnacks<cr>', desc = 'Open a picker' },
      { '<leader>eS', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
      { '<leader>es', '<cmd>EcologShelterToggle<cr>', desc = 'Ecolog shelter toggle' },		},
		lazy = false,
		config = function()
			require("ecolog").setup({
				interpolation = {
					enabled = true,
					max_iterations = 10,
					warn_on_undefined = true,
					fail_on_cmd_error = false,
					features = {
						variables = true, -- Enable variable interpolation ($VAR, ${VAR})
						defaults = true, -- Enable default value syntax (${VAR:-default})
						alternates = true, -- Enable alternate value syntax (${VAR-alternate})
						commands = true, -- Enable command substitution ($(command))
						escapes = true, -- Enable escape sequences (\n, \t, etc.)
					},
				},
				load_shell = false,
				integrations = {
					blink_cmp = true,
					snacks = {
						shelter = {
							mask_on_copy = false, -- Whether to mask values when copying
						},
						keys = {
							copy_value = "<C-y>", -- Copy variable value to clipboard
							copy_name = "<C-u>", -- Copy variable name to clipboard
							append_value = "<C-a>", -- Append value at cursor position
							append_name = "<CR>", -- Append name at cursor position
							edit_var = "<C-e>", -- Edit environment variable
						},
						layout = { -- Any Snacks layout configuration
							preset = "dropdown",
							preview = false,
						},
					},
				},
				shelter = {
					configuration = {
						partial_mode = {
							show_start = 3,
							show_end = 3,
							min_mask = 3,
						},
						mask_char = "*",
						mask_length = nil,
						skip_comments = false,
					},
					modules = {
						peek = false,
						files = true,
						snacks_previewer = false,
						snacks = false,
					},
				},
				types = true,
				path = vim.fn.getcwd(),
				preferred_environment = "development",
				provider_patterns = true,
			})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"fang2hou/blink-copilot",
			{
				"L3MON4D3/LuaSnip", -- Snippet engine
				version = "v2.*", -- Follow the latest release
			},
			"saghen/blink.compat",
			"t3ntxcl3s/ecolog.nvim",
		},
		version = "1.*",
		opts = {
			keymap = {
				["<S-CR>"] = { "accept", "fallback" },
				["<C-y>"] = { "accept", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<Tab>"] = {
					function(cmp)
						return cmp.select_next()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						return cmp.select_prev()
					end,
					"snippet_backward",
					"fallback",
				},
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<A-p>"] = { "select_prev", "fallback" },
				["<A-n>"] = { "select_next", "fallback" },
				["<A-e>"] = { "scroll_documentation_up", "fallback" },
				["<A-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-l>"] = { "snippet_forward" },
				["<C-h>"] = { "snippet_backward" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				documentation = {
					auto_show = true,
					treesitter_highlighting = true,
					auto_show_delay_ms = 250,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						treesitter = { "lsp" },
					},
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = {
				enabled = true,
			},
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"copilot",
					"ecolog",
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							max_completions = 4,
							kind_icon = " ",
						},
					},
					ecolog = {
						name = "ecolog",
						module = "ecolog.integrations.cmp.blink_cmp",
					},
					path = {
						opts = {
							get_cwd = function(_)
								return vim.fn.get_cwd()
							end,
						},
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
