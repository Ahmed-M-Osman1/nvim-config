return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "EdenEast/nightfox.nvim", lazy = false,  priority = 1000 }, -- lazy
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
  },
  { -- Auto setup LSPs
    'williamboman/mason-lspconfig.nvim',
  },
}
