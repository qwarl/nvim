return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "InsertLeave" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			markdown = { "markdownlint-cli2" },
      python = { "pylint" },
      sh = { "shellcheck" },
      typescript = { "eslint_d" },
      typscriptreact = { "eslint_d" },
		}

		lint.linters.eslint_d = require("lint.util").wrap(lint.linters.eslint_d, function(diagnostic)
			-- try to ignore "No ESLint configuration found" error
			-- if diagnostic.message:find("Error: No ESLint configuration found") then -- old version
			-- update: 20240814, following is working
			if diagnostic.message:find("Error: Could not find config file") then
				return nil
			end
			return diagnostic
		end)

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>tl", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		vim.keymap.set("n", "<leader>cl", function()
			if vim.diagnostic.is_enabled() then
				vim.diagnostic.enable(false)
			else
				vim.diagnostic.enable(true)
			end
		end, { desc = "toggle lint" })
	end,
}
