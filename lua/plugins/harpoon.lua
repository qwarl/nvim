return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
  enabled = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	keys = function()
		local harpoon = require("harpoon")
		harpoon:setup({})
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end
			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		local keys = {
			{
				"<leader>he",
				function()
					toggle_telescope(harpoon:list())
				end,
				{ desc = "Open Harpoon Window" },
			},
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				{ desc = "Harpoon Mark" },
			},
			{
				"<leader>hr",
				function()
					harpoon:list():remove()
				end,
				{ desc = "Harpoon Unmark" },
			},

			-- Toggle previous & next buffers stored within Harpoon list
			{
				"<M-,>",
				function()
					harpoon:list():prev()
				end,
				{ desc = "Previous Harpoon Mark" },
			},
			{
				"<M-.>",
				function()
					harpoon:list():next()
				end,
				{ desc = "Next Harpoon Mark" },
			},
		}

		for i = 1, 9 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
