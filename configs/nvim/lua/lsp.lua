local lspconfig = require "lspconfig"
local wk = require("which-key")

vim.lsp.protocol.CompletionItemKind = {
  " [text]",
  " [method]",
  " [function]",
  " [constructor]",
  "ﰠ [field]",
  " [variable]",
  " [class]",
  " [interface]",
  " [module]",
  " [property]",
  " [unit]",
  " [value]",
  " [enum]",
  " [key]",
  "﬌ [snippet]",
  " [color]",
  " [file]",
  " [reference]",
  " [folder]",
  " [enum member]",
  " [constant]",
  " [struct]",
  "⌘ [event]",
  " [operator]",
  "♛ [type]"
}

local on_attach = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"})
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"})

  require "lsp_signature".on_attach(
    {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "single"
      }
    }
  )

  local mappings = {
    d = {
      name = "diagnostics",
      j = {":lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic"},
      k = {":lua vim.lsp.diagnostic.goto_prev()<CR>", "Previous diagnostic"},
      l = {":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Line diagnostics"}
    },
    c = {
      name = "code", -- optional group name
      a = {":lua vim.lsp.buf.code_action()<CR>", "Code action"},
      d = {":lua vim.lsp.buf.definition()<CR>", "Goto definition"},
      r = {":lua vim.lsp.buf.rename()", "Rename"}
    }
  }
  wk.register(mappings, {prefix = "<leader>"})
end

local function setup_servers()
  local servers = { "pyright", "sumneko_lua", "rnix" }
  for _, server in pairs(servers) do
    if server == "sumneko_lua" then
      lspconfig[server].setup {on_attach = on_attach, settings = {Lua = {diagnostics = {globals = {"vim"}}}}}
    else
      lspconfig[server].setup {on_attach = on_attach}
    end
  end
end

setup_servers()
