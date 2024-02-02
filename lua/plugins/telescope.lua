return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {})
			vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", {})
			vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", {})

			vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", {})
			vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", {})
			vim.keymap.set("n", "<leader>gl", ":Telescope git_commits<CR>", {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["frecency"] = {
						-- db_root = "",
            -- ECU checkout path
						db_root = "/data/yuzhliu/latest/",
						show_scores = false,
						show_unindexed = true,
						ignore_patterns = { "*.git/*", "*/tmp/*" },
						disable_devicons = false,
						-- workspaces = {
						-- 	["conf"] = "/home/my_username/.config",
						-- 	["data"] = "/home/my_username/.local/share",
						-- 	["project"] = "/home/my_username/projects",
						-- 	["wiki"] = "/home/my_username/wiki",
						-- },
					},
				},
			})

			require("telescope").load_extension("frecency")
			vim.keymap.set("n", "<leader>fr", "<Cmd>Telescope frecency<CR>")
		end,
	},
}
