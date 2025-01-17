return {
  'ThePrimeagen/refactoring.nvim',
  name = 'refactoring',
  event = 'BufEnter',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
  },
  config = function()
    local refactoring = require('refactoring')

    refactoring.setup({})

    require('telescope').load_extension('refactoring')

    local opts = { noremap = true, silent = true, expr = false }
    local setDesc = require('config.utils').getDescWithMapOptsSetter(opts)

    -- Remaps for the refactoring operations currently offered by the plugin
    vim.keymap.set(
      'v',
      '<leader>rf',
      [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
      setDesc('Extract function')
    )
    vim.keymap.set(
      'v',
      '<leader>rF',
      [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
      setDesc('Extract function to a new file')
    )
    vim.keymap.set(
      'v',
      '<leader>re',
      [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
      setDesc('Extract variable')
    )
    vim.keymap.set(
      'v',
      '<leader>ri',
      [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
      setDesc('Inline variable')
    )

    -- Extract block doesn't need visual mode
    vim.keymap.set(
      'n',
      '<leader>rb',
      [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
      setDesc('Extract block')
    )
    vim.keymap.set(
      'n',
      '<leader>rB',
      [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
      setDesc('Extract block to a new file')
    )

    -- Inline variable can also pick up the identifier currently under the cursor without visual mode
    vim.keymap.set(
      'n',
      '<leader>ri',
      [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
      setDesc('Inline variable')
    )

    -- prompt for a refactor to apply when the remap is triggered
    vim.keymap.set(
      'v',
      '<leader>rr',
      "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      setDesc('Select refactor')
    )

    vim.keymap.set(
      'n',
      '<leader>rp',
      ":lua require('refactoring').debug.printf({below = false})<CR>",
      setDesc('Print variable above')
    )

    -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
    vim.keymap.set(
      'n',
      '<leader>rv',
      ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
      setDesc('Print variable')
    )
    -- Remap in visual mode will print whatever is in the visual selection
    vim.keymap.set(
      'v',
      '<leader>rv',
      ":lua require('refactoring').debug.print_var({})<CR>",
      setDesc('Print variable')
    )

    -- Cleanup function: this remap should be made in normal mode
    vim.keymap.set(
      'n',
      '<leader>rc',
      ":lua require('refactoring').debug.cleanup({})<CR>",
      setDesc('Cleanup')
    )
  end,
}
