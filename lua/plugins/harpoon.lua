return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({})

		-- Function to generate items for Snacks.picker
		local function harpoon_snacks_picker()
			local file_paths = {}
			for idx, item in ipairs(harpoon:list().items) do
				table.insert(file_paths, {
					text = item.value, -- Display text
					file = item.value, -- File path for preview and selection
					idx = idx, -- Store index for actions like deletion
				})
			end
			require("snacks").picker({
				finder = function()
					return file_paths
				end,
				win = {
					list = {
						keys = {
							["dd"] = { "harpoon_delete", mode = { "n", "x" } },
						},
					},
				},
				actions = {
					harpoon_delete = function(picker, item)
						local to_remove = item or picker:selected()
						if to_remove and to_remove.idx then
							harpoon:list():remove_at(to_remove.idx)
							picker:find({ refresh = true }) -- Refresh picker
						end
					end,
				},
			})
		end

		-- Define keybindings
		local keys = {
			{
				"<leader>he",
				function()
					harpoon_snacks_picker()
				end,
				desc = "Open Harpoon Window",
			},
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon Mark",
			},
			{
				"<leader>hr",
				function()
					harpoon:list():remove()
				end,
				desc = "Harpoon Unmark",
			},
			{
				"<M-,>",
				function()
					harpoon:list():prev()
				end,
				desc = "Previous Harpoon Mark",
			},
			{
				"<M-.>",
				function()
					harpoon:list():next()
				end,
				desc = "Next Harpoon Mark",
			},
		}

		-- Add number keybindings (1-9)
		for i = 1, 9 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end

		-- Register keybindings
		for _, key in ipairs(keys) do
			vim.keymap.set("n", key[1], key[2], { desc = key.desc })
		end
	end,
}
