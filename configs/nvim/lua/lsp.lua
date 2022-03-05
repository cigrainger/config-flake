local lspconfig = require("lspconfig")
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
	"♛ [type]",
}

local on_attach = function(client)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "single" }
	)

	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "single",
		},
	})

	if client.name == "rnix" or client.name == "elixirls" or client.name == "rust_analyzer" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
      augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]])
	end

	local mappings = {
		d = {
			name = "diagnostics",
			j = { ":lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic" },
			k = { ":lua vim.lsp.diagnostic.goto_prev()<CR>", "Previous diagnostic" },
			l = { ':lua vim.diagnostic.open_float({scope="line"})<CR>', "Line diagnostics" },
		},
		c = {
			name = "code", -- optional group name
			a = { ":lua vim.lsp.buf.code_action()<CR>", "Code action" },
			d = { ":lua vim.lsp.buf.definition()<CR>", "Goto definition" },
			r = { ":lua vim.lsp.buf.rename()", "Rename" },
		},
	}
	wk.register(mappings, { prefix = "<leader>" })
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function setup_servers()
	local servers = { "pyright", "sumneko_lua", "rnix", "elixirls", "zls" }
	for _, server in pairs(servers) do
		if server == "sumneko_lua" then
			lspconfig[server].setup({
				on_attach = on_attach,
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
				capabilities = capabilities,
			})
		elseif server == "elixirls" then
			lspconfig[server].setup({
				on_attach = on_attach,
				cmd = { "/etc/elixir-ls/language_server.sh" },
				capabilities = capabilities,
			})
		else
			lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
		end
	end
end

setup_servers()
require("rust-tools").setup({ server = { on_attach = on_attach } })

require("null-ls").setup({
	on_attach = on_attach,
	sources = {
		-- Formatting
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.clang_format,
		require("null-ls").builtins.formatting.erlfmt,
		require("null-ls").builtins.formatting.eslint_d,
		require("null-ls").builtins.formatting.fixjson,
		require("null-ls").builtins.formatting.format_r,
		require("null-ls").builtins.formatting.isort,
		require("null-ls").builtins.formatting.mix,
		require("null-ls").builtins.formatting.nixfmt,
		require("null-ls").builtins.formatting.pg_format,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.protolint,
		require("null-ls").builtins.formatting.rustfmt,
		require("null-ls").builtins.formatting.shellharden,
		require("null-ls").builtins.formatting.shfmt,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.taplo,
		require("null-ls").builtins.formatting.terraform_fmt,
		require("null-ls").builtins.formatting.trim_newlines,
		require("null-ls").builtins.formatting.trim_whitespace,
		require("null-ls").builtins.formatting.xmllint,
		require("null-ls").builtins.formatting.zigfmt,
		require("null-ls").builtins.formatting.rustywind.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"html",
				"elixir",
				"heex",
			},
		}),
		-- Diagnostics
		require("null-ls").builtins.diagnostics.actionlint,
		require("null-ls").builtins.diagnostics.checkmake,
		require("null-ls").builtins.diagnostics.codespell,
		require("null-ls").builtins.diagnostics.credo,
		require("null-ls").builtins.diagnostics.eslint_d,
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.luacheck,
		require("null-ls").builtins.diagnostics.mdl,
		require("null-ls").builtins.diagnostics.mdl,
		require("null-ls").builtins.diagnostics.mypy,
		require("null-ls").builtins.diagnostics.protoc_gen_lint,
		require("null-ls").builtins.diagnostics.shellcheck,
		require("null-ls").builtins.diagnostics.statix,
		-- Code actions
		require("null-ls").builtins.code_actions.eslint_d,
		require("null-ls").builtins.code_actions.gitsigns,
		require("null-ls").builtins.code_actions.statix,
		-- Completion
		require("null-ls").builtins.completion.spell,
	},
})
