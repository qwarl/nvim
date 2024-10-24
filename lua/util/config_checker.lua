local M = {}

local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

function M.exists_in_config(path)
	return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
end

return M
