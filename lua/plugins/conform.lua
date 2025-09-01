return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "nixfmt" },
				python = { "black", "isort", },
				sh = { "shfmt" },
				toml = { "taplo" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = function(bufnr)
				-- Check if global or buffer-local variable enables autoformat
				if vim.g.enable_autoformat or vim.b[bufnr].enable_autoformat then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
				return nil -- Disable auto-format on save by default
			end,
		})

		-- Command to enable auto-format on save globally or for the current buffer only
		vim.api.nvim_create_user_command("FormatEnable", function(args)
			if args.bang then
				-- Enable formatting only for the current buffer with FormatEnable!
				vim.b.enable_autoformat = true
				print("Auto-format on save enabled for this buffer")
			else
				-- Enable formatting globally
				vim.g.enable_autoformat = true
				print("Auto-format on save enabled globally")
			end
		end, {
			desc = "Enable autoformat-on-save (use ! for buffer only)",
			bang = true,
		})

		-- Command to disable auto-format on save globally or for the current buffer only
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- Disable formatting only for the current buffer with FormatDisable!
				vim.b.enable_autoformat = false
				print("Auto-format on save disabled for this buffer")
			else
				-- Disable formatting globally
				vim.g.enable_autoformat = false
				print("Auto-format on save disabled globally")
			end
		end, {
			desc = "Disable autoformat-on-save (use ! for buffer only)",
			bang = true,
		})
	end,
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
			end,
			mode = { "n", "v" },
			desc = "Format file or range",
		},
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
		{
			"<leader>uF",
			function()
				if vim.g.enable_autoformat then
					vim.cmd("FormatDisable")
				else
					vim.cmd("FormatEnable")
				end
			end,
			mode = "n",
			desc = "Toggle Auto Format (Global)",
		},
		{
			"<leader>uf",
			function()
				if vim.b.enable_autoformat then
					vim.cmd("FormatDisable!")
				else
					vim.cmd("FormatEnable!")
				end
			end,
			mode = "n",
			desc = "Toggle Auto Format (Buffer)",
		},
	},
}
