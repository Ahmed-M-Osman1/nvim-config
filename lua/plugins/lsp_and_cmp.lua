return {
  {
    -- LSP config helper
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      require('config.lsp')
    end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
    },
  },
  {
    -- typescript
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },
  {
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter' },
    lazy = false,
    config = function()
      require('config.cmp')
    end,
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'kdheepak/cmp-latex-symbols' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
  }
}
