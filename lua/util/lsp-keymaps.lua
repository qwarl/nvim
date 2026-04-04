local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end
  -- stylua: ignore
  M._keys = {
    { "<leader>cl", function() Snacks.picker.lsp_config() end,          desc = "Lsp Info" },
    { "gd",         vim.lsp.buf.definition,                             desc = "Goto Definition",            has = "definition" },
    { "gr",         vim.lsp.buf.references,                             desc = "References",                 nowait = true },
    { "gI",         vim.lsp.buf.implementation,                         desc = "Goto Implementation" },
    { "gy",         vim.lsp.buf.type_definition,                        desc = "Goto T[y]pe Definition" },
    { "gD",         vim.lsp.buf.declaration,                            desc = "Goto Declaration" },
    { "K",          function() return vim.lsp.buf.hover() end,          desc = "Show Hover Information" },
    { "gK",         function() return vim.lsp.buf.signature_help() end, desc = "Signature Help",             has = "signatureHelp" },
    { "<c-k>",      function() return vim.lsp.buf.signature_help() end, mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
    { "<leader>ca", vim.lsp.buf.code_action,                            desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run,                               desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh,                           desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
    { "<leader>cR", function() Snacks.rename.rename_file() end,         desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { "<leader>rn", vim.lsp.buf.rename,                                 desc = "Rename",                     has = "rename" },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {}, }, })
      end,
      desc = "Source Action",
      has = "codeAction"
    },
    {
      "]]",
      function() Snacks.words.jump(vim.v.count1) end,
      has = "documentHighlight",
      desc = "Next Reference",
      cond = function() return Snacks.words.is_enabled() end
    },
    {
      "[[",
      function() Snacks.words.jump(-vim.v.count1) end,
      has = "documentHighlight",
      desc = "Prev Reference",
      cond = function() return Snacks.words.is_enabled() end
    },
    {
      "<a-n>",
      function() Snacks.words.jump(vim.v.count1, true) end,
      has = "documentHighlight",
      desc = "Next Reference",
      cond = function() return Snacks.words.is_enabled() end
    },
    {
      "<a-p>",
      function() Snacks.words.jump(-vim.v.count1, true) end,
      has = "documentHighlight",
      desc = "Prev Reference",
      cond = function() return Snacks.words.is_enabled() end
    },
  }

  return M._keys
end

function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client:supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = M.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

return M
