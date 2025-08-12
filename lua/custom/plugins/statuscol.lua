return {
  'luukvbaal/statuscol.nvim',
  config = function()
    -- Custom function to show both absolute and relative line numbers
    local builtin = require 'statuscol.builtin'
    local function lnum_both()
      local lnum = vim.v.lnum
      local relnum = vim.v.lnum == vim.fn.line '.' and 0 or math.abs(vim.v.lnum - vim.fn.line '.')
      return string.format('%3d %2d', lnum, relnum)
    end
    require('statuscol').setup {
      setopt = true,
      ft_ignore = { 'neo-tree' },
      segments = {
        {
          sign = {
            namespace = { 'gitsigns.*' },
            name = { 'gitsigns.*' },
            wrap = false,
          },
        },
        {
          sign = {
            namespace = { '.*' },
            name = { '.*' },
            colwidth = 1,
            wrap = false,
          },
        },
        {
          text = { lnum_both, ' ' },
          condition = {
            -- don't show on wrapped lines
            function()
              return vim.v.virtnum == 0
            end,
          },
          click = 'v:lua.ScLa',
        },
      },
    }
  end,
}
