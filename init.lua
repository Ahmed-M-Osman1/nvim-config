local utils = require('config.utils')

-- Vim options
vim.opt.background = 'dark' -- "\"dark\" or \"light\", used for highlight colors"

-- vim.opt.termguicolors = true -- Terminal true color support

vim.opt.modeline = true -- recognize modelines at start or end of file
vim.opt.modelines = 4 -- number of lines checked for modelines

vim.opt.updatetime = 150 -- after this many milliseconds flush swap file

vim.opt.cmdheight = 0 -- number of lines to use for the command-line

vim.opt.smartcase = true -- no ignore case when pattern has uppercase
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.incsearch = true -- highlight match while typing search pattern

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.softtabstop = 2 -- number of spaces that <Tab> uses while editing
vim.opt.smartindent = true -- smart autoindenting for C programs
-- vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.wrap = false -- lines wrap and continue on the next line

vim.opt.undodir = utils.config_location .. '/undodir' -- where to store undo files
vim.opt.undofile = true -- save undo information in a file
vim.opt.undolevels = 5000 -- maximum number of changes that can be undone

-- vim.opt.lazyredraw = true -- don't redraw while executing macros

vim.opt.relativenumber = true -- show relative line number in front of each line
vim.opt.number = true -- show relative line number in front of each line
vim.opt.scrolloff = 8 -- minimum nr. of lines above and below cursor
vim.opt.mouse = 'a' -- the use of mouse clicks
vim.opt.colorcolumn = '80' -- columns to highlight

vim.opt.showmode = false -- message on status line to show current mode
vim.opt.backup = false -- keep backup file after overwriting a file
vim.opt.errorbells = false -- ring the bell for error messages
vim.opt.writebackup = false -- make a backup before overwriting a file
vim.opt.swapfile = false -- whether to use a swapfile for a buffer
vim.opt.hlsearch = true --  highlight matches with last search pattern
vim.opt.laststatus = 3 -- global status line

-- Fold stuff
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = 'indent'

vim.opt.mousemodel = 'extend'

-- Disable these plugins for faster startup
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_spec = 1
vim.g.loaded_perl_provider = 1 -- Perl provider
vim.g.loaded_ruby_provider = 1 -- Ruby provider
vim.g.loaded_python_provider = 1 -- Python provider
vim.g.loaded_node_provider = 1 -- Node provider

-- Load config and plugins
require('init')
