local M = {}
-- local methods = vim.lsp.protocol.Methods

-- document_highlight
local function lsp_highlight_document(bufnr)
  --- Kept for backwards compatibility, will remove in the future
  -- vim.cmd([[
  --     hi! LspReferenceRead cterm=underline ctermbg=red gui=underline guibg=#24283b
  --     hi! LspReferenceText cterm=underline ctermbg=red guibg=#24283b
  --     hi! LspReferenceWrite cterm=underline ctermbg=red  guibg=#24283b
  --   ]])
  -- Check if client supports documentHighlight
  if not vim.lsp.buf.document_highlight then
    return
  end

  vim.api.nvim_set_hl(0, 'LspReferenceRead', {
    underline = true,
    bg = '#24283b',
    ctermbg = 'red',
  })
  vim.api.nvim_set_hl(0, 'LspReferenceText', {
    underline = true,
    bg = '#24283b',
    ctermbg = 'red',
  })
  vim.api.nvim_set_hl(0, 'LspReferenceWrite', {
    underline = true,
    bg = '#24283b',
    ctermbg = 'red',
  })
  vim.api.nvim_create_augroup('lsp_document_highlight', {
    clear = false,
  })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = 'lsp_document_highlight',
  })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = 'lsp_document_highlight',
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = 'lsp_document_highlight',
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

local beforeFormat = nil

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  if vim.b[bufnr].is_big_file then
    return
  end

  local mapOpts = { noremap = true, silent = true, buffer = bufnr }
  local setDesc = require('config.utils').getDescWithMapOptsSetter(mapOpts)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value(
    'omnifunc',
    'v:lua.vim.lsp.omnifunc',
    { buf = bufnr }
  )

  ----- Mappings.
  ---- Deprecated
  --- CTRL-S -> vim.lsp.buf.signature\_help()
  vim.keymap.set(
    'n',
    '<C-k>',
    vim.lsp.buf.signature_help,
    setDesc('Opens signature help')
  )
  --- crr -> vim.lsp.buf.code_action()
  -- For visual CTRL-R CTRL-R (also CTRL-R r) -> vim.lsp.buf.code_action()
  -- vim.keymap.set(
  --   { 'n', 'v' },
  --   '<leader>ca',
  --   vim.lsp.buf.code_action,
  --   setDesc('Code action')
  -- )
  --- overriden by crn -> vim.lsp.buf.rename()
  -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, setDesc('Rename'))

  -- Info
  vim.keymap.set(
    'n',
    '<leader>xw',
    '<cmd>Trouble workspace_diagnostics<cr>',
    setDesc('Opens workspace diagnostics')
  )
  vim.keymap.set(
    'n',
    '<leader>xd',
    '<cmd>Trouble document_diagnostics<cr>',
    setDesc('Opens document diagnostics')
  )

  -- Overrides gr -> vim.lsp.buf.references()
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>Trouble lsp_references<cr>',
    setDesc('LspReferences for word under cursor')
  )
  vim.keymap.set(
    'n',
    '<leader>e',
    vim.diagnostic.open_float,
    setDesc('Opens diagnostics in float')
  )

  -- Docs
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, setDesc('Opens hover doc'))

  -- Go To
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, setDesc('Go to definition'))
  vim.keymap.set(
    'n',
    'gD',
    vim.lsp.buf.declaration,
    setDesc('Go to declaration')
  )
  vim.keymap.set(
    'n',
    'gi',
    vim.lsp.buf.implementation,
    setDesc('Go to implemntation')
  )
  vim.keymap.set(
    'n',
    '<leader>gt',
    vim.lsp.buf.type_definition,
    setDesc('Go to type definition')
  )

  -- Workspace
  vim.keymap.set(
    'n',
    '<leader>Wa',
    vim.lsp.buf.add_workspace_folder,
    setDesc('Adds the folder to the workspace.')
  )
  vim.keymap.set(
    'n',
    '<leader>Wr',
    vim.lsp.buf.remove_workspace_folder,
    setDesc('Removes the folder from workspace.')
  )
  vim.keymap.set('n', '<leader>Wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, setDesc('Lists workspace folders'))

  -- Actions
  vim.keymap.set(
    'n',
    '<leader>fs',
    require('telescope.builtin').lsp_document_symbols,
    setDesc('Opens document symbols')
  )

  vim.api.nvim_create_user_command('LspCodeAction', function()
    vim.lsp.buf.code_action()
  end, { nargs = 0, desc = 'Code action' })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
      vim.api.nvim_create_autocmd('BufDelete', {
        buffer = vim.api.nvim_get_current_buf(),
        callback = function(opts)
          local bufnum = opts.buf
          local clients = vim.lsp.get_clients({ bufnr = bufnum })
          for client_id, attached_client in pairs(clients) do
            if attached_client.name == 'copilot' then
              return
            end
            vim.lsp.buf_detach_client(bufnum, client_id)
          end
        end,
      })
    end,
  })

  -- Highlight used words
  if client.server_capabilities.documentHighlightProvider then
    lsp_highlight_document(bufnr)
  end

  -- https://reddit.com/r/neovim/s/eDfG5BfuxW
  -- if client.supports_method(methods.textDocument_inlayHint) then
  -- end
  if vim.lsp.inlay_hint then
    local hintFilter = { bufnr = bufnr }
    -- Toggle inlay hints
    vim.keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled(hintFilter),
        hintFilter
      )
    end, { expr = true, noremap = true, desc = '[T]oggle inlay [h]ints' })

    -- Enable them by default.
    vim.lsp.inlay_hint.enable(true, hintFilter)
  end

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          'BufLeave',
          'CursorMoved',
          'InsertEnter',
          'FocusLost',
        },
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })

  if client.name == 'typescript-tools' or client.name == 'tsserver' then
    beforeFormat = function()
      vim.cmd('TSToolsAddMissingImports sync')
      -- vim.cmd('TSToolsSortImports sync')
      -- vim.cmd('TSToolsRemoveUnusedImports sync')
      vim.cmd('TSToolsOrganizeImports sync') -- Does both sort and remove
      -- vim.cmd('TSToolsFixAll sync')
    end
  end

  -- For formatting
  if client.supports_method('textDocument/formatting') then
    -- Create a cmd to format the buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'LspFormat', function(_)
      if vim.lsp.buf.format then
        vim.lsp.buf.format()
      elseif vim.lsp.buf.formatting then
        vim.lsp.buf.formatting()
      end
    end, { desc = 'Format current buffer with LSP' })

    -- Map <leader>F to format the buffer
    vim.keymap.set('n', '<leader>F', function()
      vim.lsp.buf.format({ async = true })
    end, setDesc('Formats file'))

    --- Create a cmd to stop autoformatting by clearing the autocmd
    vim.api.nvim_buf_create_user_command(bufnr, 'LspFormatStop', function(_)
      vim.cmd([[
      augroup LspFormatting
        autocmd! BufWritePre <buffer>
      augroup END
      ]])
    end, { desc = 'Stop autoformatting on save' })
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if beforeFormat then
          beforeFormat()
        end
        vim.lsp.buf.format({
          -- async = true,
          bufnr = bufnr,
          filter = function(client_format)
            if client_format.name == 'efm' then
              return true
            end
            -- Use only null_ls for now.
            return client_format.name == 'null-ls'
          end,
        })
      end,
    })
  end
end

-- Set the signs to this
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(
    sign.name,
    { texthl = sign.name, text = sign.text, numhl = '' }
  )
end

-- -- Default settings
-- local border = {
--   { '╭', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '╮', 'FloatBorder' },
--   { '│', 'FloatBorder' },
--   { '╯', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '╰', 'FloatBorder' },
--   { '│', 'FloatBorder' },
-- }

vim.diagnostic.config({
  float = {
    source = 'always',
    focusable = true,
    style = 'minimal',
    border = 'rounded',
  },
  underline = true,
  signs = true,
  severity_sort = true,
  virtual_text = {
    spacing = 2,
    source = 'always',
    prefix = '',
  },
})

M.handlers = {
  ['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
  ),
  ['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  ),
}

M.default_opts = {
  autoSetHints = true,
  handlers = M.handlers,
  inlay_hints = { enabled = true },
  noremap = true,
  silent = true,
  on_attach = M.on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  format = true,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

M.default_opts.capabilities.textDocument.completion.completionItem.snippetSupport =
  true

return M
