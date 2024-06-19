return {
  "folke/noice.nvim",
  event = "VeryLazy",
keys = { 
    {
    '<C-space>',
    '<cmd>Noice dismiss<CR><cmd>lua require("fidget.notification").clear()<CR>',
     desc = 'Dismiss notifications' 
    }
  },
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    }
}
