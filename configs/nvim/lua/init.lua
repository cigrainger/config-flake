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
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

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
opt("o", "completeopt", "menuone,noinsert,noselect") -- Completion options (for deoplete)
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

g.term = "screen-256color"

cmd "colorscheme dracula"

-- vim-slime
g.slime_target = "tmux"
g.slime_python_ipython = 1

-- Mappings

-- Nopes
local mappings = {
  ["<up>"] = {"<nop>", "Nope"},
  ["<down>"] = {"<nop>", "Nope"},
  ["<left>"] = {"<nop>", "Nope"},
  ["<right>"] = {"<nop>", "Nope"}
}
wk.register(mappings, {})
mappings = {
  ["<up>"] = {"<nop>", "Nope"},
  ["<down>"] = {"<nop>", "Nope"},
  ["<left>"] = {"<nop>", "Nope"},
  ["<right>"] = {"<nop>", "Nope"}
}
wk.register(mappings, {mode = "i"})

-- mapleaderapleader to space. Needs to be before other mappings.
g.mapleader = " "

-- Common top level mappings
mappings = {
  K = {":lua vim.lsp.buf.hover()<CR>", "Hover"},
  ["<leader>l"] = {"<cmd>noh<CR>", "Clear highlights"},
  ["<leader>o"] = {"m`o<Esc>``", "Insert newline"},
  ["<leader>lg"] = {":LazyGit<CR>", "LazyGit"},
  ["<leader>r"] = {"<Plug>RestNvim", "REST Client"}
}
wk.register(mappings)

-- Completion menu tab nav
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('C-e')", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {silent = true, expr = true})
vim.api.nvim_exec(
  [[
" NOTE: You can use other key to expand snippet.

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.elixir = ['elixir', 'html', 'css']
]],
  true
)

-- FZF

mappings = {
  f = {
    name = "find",
    f = {":Files <CR>", "Files"},
    h = {":Helptags <CR>", "Help"},
    g = {":Rg <CR>", "Lines"},
    b = {":Buffers <CR>", "Buffers"},
    r = {":References <CR>", "References"},
    d = {":Diagnostics <CR>", "Diagnostics"},
    z = {":BLines <CR>", "Current buffer fuzzy"},
  }
}
wk.register(mappings, {prefix = "<leader>"})

-- Square brackets
mappings = {
  ["]"] = {
    name = "next",
    c = "Chunk"
  },
  ["["] = {
    name = "prev",
    c = "Chunk"
  }
}
wk.register(mappings, {})

-- Buffers
mappings = {
  b = {
    name = "buffers",
    d = {":bd<CR>", "Close"},
    n = {":enew<CR>", "New"}
  }
}
wk.register(mappings, {prefix = "<leader>"})

-- vim-test
mappings = {
  e = {
    name = "test",
    n = {":TestNearest<CR>", "Nearest"},
    f = {":TestFile<CR>", "File"},
    s = {":TestSuite<CR>", "Suite"},
    l = {":TestLast<CR>", "Last"},
    g = {":TestVisit<CR>", "Visit"}
  }
}
wk.register(mappings, {prefix = "<leader>"})

-- nvim-tree
wk.register({["<C-n>"] = {":NvimTreeToggle<CR>", "Toggle tree"}}, {})

-- Treesitter
local ts = require "nvim-treesitter.configs"
ts.setup {ensure_installed = "maintained", highlight = {enable = true}}
vim.cmd "autocmd BufRead,BufNewFile *.ex,*.exs,mix.lock set filetype=elixir"

require "compe".setup(
  {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
      path = true,
      buffer = true,
      calc = true,
      nvim_lsp = true,
      nvim_lua = true,
      vsnip = true
    }
  }
)

require("which-key").setup {}
require("todo-comments").setup {}
require("gitsigns").setup()
require("lualine").setup(
  {
    options = {theme = "dracula"}
  }
)

-- LSP
require "lsp"
require("rust-tools").setup()

require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      terraform = {
        function()
          return {
            exe = "terraform fmt",
            args = {"-write=true", "-list=false"},
            stdin = false
          }
        end
      }
    }
  }
)
