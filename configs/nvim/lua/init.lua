-- Aliases
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
-- local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local wk = require("which-key")

-- Options
--[[
Citation: https://oroques.dev/notes/neovim-init/
The Neovim Lua API provide 3 tables to set options:

vim.o for setting global options
vim.bo for setting buffer-scoped options
vim.wo for setting window-scoped options

Unfortunately setting an option is not as straightforward in Lua as in Vimscript. In Lua you need to update the global table then either the buffer-scoped or the window-scoped table to ensure that an option is correctly set. Otherwise some option like expandtab will only be valid for the starting buffer of a new Neovim instance.

Fortunately the Neovim team is working on an universal and simpler option interface. In the meantime you can use this function as a workaround:
--]]
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function opt(scope, key, value)
	scopes[scope][key] = value
	if scope ~= "o" then
		scopes["o"][key] = value
	end
end

local indent = 2
opt("b", "expandtab", true) -- Use spaces instead of tabs
opt("b", "shiftwidth", indent) -- Size of an indent
opt("b", "smartindent", true) -- Insert indents automatically
opt("b", "undofile", true) -- Persist undo
opt("b", "tabstop", indent) -- Number of spaces tabs count for
opt("o", "incsearch", true) -- Turn on incremental search.
opt("o", "completeopt", "menu,menuone,noselect") -- Completion options (for deoplete)
opt("o", "hidden", true) -- Enable modified buffers in background
opt("o", "ignorecase", true) -- Ignore case
opt("o", "joinspaces", false) -- No double spaces with join after a dot
opt("o", "scrolloff", 4) -- Lines of context
opt("o", "shiftround", true) -- Round indent
opt("o", "sidescrolloff", 8) -- Columns of context
opt("o", "smartcase", true) -- Don't ignore case with capitals
opt("o", "splitbelow", true) -- Put new windows below current
opt("o", "splitright", true) -- Put new windows right of current
opt("o", "termguicolors", true) -- True color support
opt("o", "wildmode", "list:longest") -- Command-line completion mode
opt("w", "list", true) -- Show some invisible characters (tabs...)
opt("w", "number", true) -- Print line number
opt("o", "timeoutlen", 400) -- Time before giving up (and showing which-key)

cmd("colorscheme dracula")

-- vim-slime
g.slime_target = "tmux"
g.slime_python_ipython = 1

-- Mappings

-- Nopes
local mappings = {
	["<up>"] = { "<nop>", "Nope" },
	["<down>"] = { "<nop>", "Nope" },
	["<left>"] = { "<nop>", "Nope" },
	["<right>"] = { "<nop>", "Nope" },
}
wk.register(mappings, {})
mappings = {
	["<up>"] = { "<nop>", "Nope" },
	["<down>"] = { "<nop>", "Nope" },
	["<left>"] = { "<nop>", "Nope" },
	["<right>"] = { "<nop>", "Nope" },
}
wk.register(mappings, { mode = "i" })

-- mapleaderapleader to space. Needs to be before other mappings.
g.mapleader = " "

-- Common top level mappings
mappings = {
	["<leader>l"] = { "<cmd>noh<CR>", "Clear highlights" },
	["<leader>o"] = { "m`o<Esc>``", "Insert newline" },
	["<leader>lg"] = { ":LazyGit<CR>", "LazyGit" },
	["<leader>r"] = { "<Plug>RestNvim", "REST Client" },
}
wk.register(mappings)

-- Telescope

local trouble = require("trouble.providers.telescope")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = { ["<c-t>"] = trouble.open_with_trouble },
			n = { ["<c-t>"] = trouble.open_with_trouble },
		},
	},
})

telescope.load_extension("fzf")

mappings = {
	f = {
		name = "find",
		f = { ":Telescope find_files<CR>", "Files" },
		h = { ":Telescope help_tags<CR>", "Help" },
		g = { ":Telescope live_grep<CR>", "Lines" },
		b = { ":Telescope buffers<CR>", "Buffers" },
		r = { ":Telescope lsp_references<CR>", "References" },
		d = { ":Telescope lsp_workspace_diagnostics<CR>", "Diagnostics" },
	},
}
wk.register(mappings, { prefix = "<leader>" })

-- Square brackets
mappings = {
	["]"] = {
		name = "next",
		c = "Chunk",
	},
	["["] = {
		name = "prev",
		c = "Chunk",
	},
}
wk.register(mappings, {})

-- Buffers
mappings = {
	b = {
		name = "buffers",
		d = { ":bd<CR>", "Close" },
		n = { ":enew<CR>", "New" },
	},
}
wk.register(mappings, { prefix = "<leader>" })

-- vim-test
mappings = {
	e = {
		name = "test",
		n = { ":TestNearest<CR>", "Nearest" },
		f = { ":TestFile<CR>", "File" },
		s = { ":TestSuite<CR>", "Suite" },
		l = { ":TestLast<CR>", "Last" },
		g = { ":TestVisit<CR>", "Visit" },
	},
}
wk.register(mappings, { prefix = "<leader>" })

-- Treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })
vim.cmd("autocmd BufRead,BufNewFile *.ex,*.exs,mix.lock set filetype=elixir")

require("which-key").setup({})
require("todo-comments").setup({})
require("gitsigns").setup({
	current_line_blame = true,
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end

		-- Navigation
		map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		-- Actions
		map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
		map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
		map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
		map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
		map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
		map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
		map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
		map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
		map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

		-- Text object
		map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
		map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
require("lualine").setup({
	options = { theme = "dracula" },
})

-- LSP
require("lsp")
require("rust-tools").setup()

-- nvim-tree
require("nvim-tree").setup()
wk.register({
	["<C-n>"] = { ":NvimTreeToggle<CR>", "Toggle tree" },
	["<leader>nr"] = { ":NvimTreeRefresh<CR>", "Refresh tree" },
	["<leader>nn"] = { ":NvimTreeFindFile<CR>", "Find file" },
}, {})

-- trouble
mappings = {
	x = {
		name = "trouble",
		x = { ":TroubleToggle <CR>", "Main" },
		w = { ":TroubleToggle lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
		d = { ":TroubleToggle lsp_document_diagnostics<CR>", "Document Diagnostics" },
		q = { ":TroubleToggle quickfix<CR>", "Quickfix" },
		l = { ":TroubleToggle loclist<CR>", "Location List" },
	},
}
wk.register(mappings, { prefix = "<leader>" })

-- cmp
local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
})

cmd("call wilder#setup({'modes': [':', '/', '?']})")
cmd([[
call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'min_width': '100%',
      \ 'max_height': '20%',
      \ 'reverse': 0,
      \ 'highlights': {
      \   'border': 'Normal',
      \ },
      \ 'border': 'rounded',
      \ 'left': [
      \   ' ', wilder#popupmenu_devicons(),
      \ ],
      \ })))
]])

require("gitsigns").setup()

-- Markdown preview
mappings = {
	m = {
		name = "Markdown Preview",
		p = { ":MarkdownPreview <CR>", "Start" },
		s = { ":MarkdownPreviewStop <CR>", "Stop" },
	},
}
wk.register(mappings, { prefix = "<leader>" })
