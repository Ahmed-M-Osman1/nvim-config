-- Mapping functions to make things easier
local utils = require('config.utils')
local nmap = utils.nmap
-- local vmap = utils.vmap
-- local imap = utils.imap
-- local xmap = utils.xmap
-- local omap = utils.omap
local cmap = utils.cmap
local nnoremap = utils.nnoremap
-- local inoremap = utils.inoremap
-- local vnoremap = utils.vnoremap
-- Test emote support: should be white skull 💀

vim.g.mapleader = ' ' -- Set leader to space

nnoremap('<leader>w', ':w<CR>', { desc = 'saves file' }) -- Saves file
nnoremap('<leader>/', ':noh <CR>', { desc = 'stops highlighting search' }) -- Stops highlighting
nnoremap('<leader>N', ':enew<CR>', { desc = 'Open a new buffer' }) -- open new buffer, normally I use it to hold a json obj to format!
nmap('<leader>l', ':bnext<CR>', { desc = 'Move to next buffer' }) -- Move to the next buffer
nmap('<leader>h', ':bprevious<CR>', { desc = 'Move to the prev buffer' }) -- Move to the previous buffer
nmap('<leader>bq', ':bp <BAR> bd #<CR>', { desc = 'Close the current buffer' }) -- Close the current buffer and move to the previous one
nmap( -- Close the current buffer and move to the previous one
  '<leader>bQ',
  ':bp <BAR> bd! #<CR>',
  { desc = 'Force close the current buffer' }
)
nmap( -- Close all buffers except this one
  '<leader>bE',
  ':silent %bd|e#|bd#<CR>',
  { desc = 'Close all buffers except one' }
)
nmap('<leader>bl', ':ls<CR>', { desc = 'List all buffers' }) -- List all buffers
