-- if vim.env.SSH_CONNECTION then
--   local osc52 = require("vim.ui.clipboard.osc52")
--
--   vim.g.clipboard = {
--     name = "OSC52",
--     copy = {
--       ["+"] = osc52.copy("+"),
--       ["*"] = osc52.copy("*"),
--     },
--     paste = {
--       ["+"] = function()
--         return { vim.fn.getreg("+") }, vim.fn.getregtype("+")
--       end,
--       ["*"] = function()
--         return { vim.fn.getreg("*") }, vim.fn.getregtype("*")
--       end,
--     },
--   }
--
--   vim.o.clipboard = "unnamedplus"
-- end


-- if vim.env.TMUX ~= nil then
--   local copy = {'tmux', 'load-buffer', '-w', '-'}
--   local paste = {'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -'}
--   vim.g.clipboard = {
--     name = 'tmux',
--     copy = {
--       ['+'] = copy,
--       ['*'] = copy,
--     },
--     paste = {
--       ['+'] = paste,
--       ['*'] = paste,
--     },
--     cache_enabled = 0,
--   }
-- end

-- Clipboard setup với logic mới
if vim.env.TMUX ~= nil and vim.env.SSH_CONNECTION then
  -- Trường hợp 1: Có cả TMUX + SSH → ưu tiên dùng TMUX
  local copy = {'tmux', 'load-buffer', '-w', '-'}
  local paste = {'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -'}

  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
    cache_enabled = 0,
  }

  vim.o.clipboard = "unnamedplus"

elseif vim.env.SSH_CONNECTION and vim.env.TMUX == nil then
  -- Trường hợp 2: Chỉ có SSH, không có TMUX → dùng OSC52
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.getreg("+") }, vim.fn.getregtype("+")
      end,
      ["*"] = function()
        return { vim.fn.getreg("*") }, vim.fn.getregtype("*")
      end,
    },
  }

  vim.o.clipboard = "unnamedplus"

end
-- Các trường hợp còn lại (chỉ TMUX hoặc không có gì) → không làm gì
