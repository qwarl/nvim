local is_path = require("util")

return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", config = true },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {"j-hui/fidget.nvim", opts = {}},
    "saghen/blink.cmp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        -- get keymaps
        local keys = require("util.lsp-keymaps").get()

        for _, key in ipairs(keys) do
          -- Kiểm tra `has` (nếu có)
          if not key.has or require("util.lsp-keymaps").has(event.buf, key.has) then
            -- Kiểm tra `cond` (nếu có)
            if not key.cond or key.cond() then
              local mode = key.mode or "n"
              local opts = { buffer = event.buf, desc = key.desc }
              if key.nowait then opts.nowait = true end
              vim.keymap.set(mode, key[1], key[2], opts)
            end
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Add vtsls special command
        if client and client.name == "vtsls" then
          -- keymaps for ts, js code
          map("gD", function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, "workspace/executeCommand", {
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
            }, function(_, result)
              if result then
                vim.lsp.util.jump_to_location(result, "utf-8")
              end
            end)
          end, "Goto Source Definition")

          -- Find All File References - TypeScript specific
          map("gR", function()
            vim.lsp.buf_request(0, "workspace/executeCommand", {
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
            }, function(_, result)
              if result then
                vim.lsp.util.locations_to_items(result, "utf-8")
                require("snacks.picker").lsp_references()
              end
            end)
          end, "File References")

          -- Organize Imports
          map("<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              }
            })
          end, "Organize Imports")

          -- Add Missing Imports
          map("<leader>cM", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.addMissingImports.ts" },
                diagnostics = {},
              }
            })
          end, "Add Missing Imports")

          -- Remove Unused Imports
          map("<leader>cu", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.removeUnused.ts" },
                diagnostics = {},
              }
            })
          end, "Remove Unused Imports")

          -- Fix All Diagnostics
          map("<leader>cD", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.fixAll.ts" },
                diagnostics = {},
              }
            })
          end, "Fix All Diagnostics")

          -- Select TypeScript Version
          map("<leader>cV", function()
            vim.lsp.buf_request(0, "workspace/executeCommand", {
              command = "typescript.selectTypeScriptVersion"
            })
          end, "Select TS Workspace Version")


          client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
            local action, uri, range = unpack(command.arguments)
            local function move(newf)
              client.request("workspace/executeCommand", {
                command = command.command,
                arguments = { action, uri, range, newf },
              })
            end
            local fname = vim.uri_to_fname(uri)
            client.request("workspace/executeCommand", {
              command = "typescript.tsserverRequest",
              arguments = {
                "getMoveToRefactoringFileSuggestions",
                {
                  file = fname,
                  startLine = range.start.line + 1,
                  startOffset = range.start.character + 1,
                  endLine = range["end"].line + 1,
                  endOffset = range["end"].character + 1,
                },
              },
            }, function(_, result)
              local files = result.body.files
              table.insert(files, 1, "Enter new path...")
              vim.ui.select(files, {
                prompt = "Select move destination:",
                format_item = function(f)
                  return vim.fn.fnamemodify(f, ":~:.")
                end,
              }, function(f)
                if f and f:find("^Enter new path") then
                  vim.ui.input({
                    prompt = "Enter move destination:",
                    default = vim.fn.fnamemodify(fname, ":h") .. "/",
                    completion = "file",
                  }, function(newf)
                    if newf then move(newf) end
                  end)
                elseif f then
                  move(f)
                end
              end)
            end)
          end
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>uh", function()
            local buf = vim.api.nvim_get_current_buf()
            local enabled = not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(enabled, { bufnr = buf })
            if enabled then
              vim.notify("Inlay hints enabled for this buffer.", vim.log.levels.INFO)
            else
              vim.notify("Inlay hints disabled for this buffer.", vim.log.levels.INFO)
            end
          end, "Toggle Inlay Hints")

          map("<leader>uH", function()
            local enabled = not vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(enabled)
            if enabled then
              vim.notify("Inlay hints enabled globally.", vim.log.levels.INFO)
            else
              vim.notify("Inlay hints disabled globally.", vim.log.levels.INFO)
            end
          end, "Inlay Hints (Global)")
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.fileOperations = {
      willRename = true,
      didRename = true,
    }

    local servers = {
      bashls = { filetypes = { "sh", "zsh" } },
      texlab = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            hint = {
              enable = true,
              arrayIndex = "Disable",
            },
          },
        },
      },
      html = {},
      cssls = {},
      tailwindcss = {},
      emmet_ls = {},
      pyright = {},
      rust_analyzer = {},
      vtsls = {
        settings = (function()
          local ts_settings = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = true },
            },
          }

          return {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = ts_settings,
            javascript = vim.tbl_deep_extend("force", {}, ts_settings),
          }
        end)(),
      },
      marksman = {},
      jsonls = {
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = { enable = true },
            validate = { enable = true },
          },
        },
      },
      taplo = {},
      yamlls = {},
    }

    if is_path.exists_in_config("hypr") then
      servers.hyprls = {}
    end

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "black",
      "eslint_d",
      "isort",
      "markdownlint-cli2",
      "markdown-toc",
      "prettier",
      "pylint",
      "shellcheck",
      "shfmt",
      "stylua",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
