-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      group_empty_dirs = true, -- combines multiple layers of one folder dirs into one entry
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- add extension names you want to explicitly exclude
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
    },
  },
  config = function()
    require('neo-tree').setup {
      event_handlers = {
        {
          event = 'neo_tree_buffer_enter',
          handler = function(arg)
            vim.cmd [[
          setlocal relativenumber
          setlocal numberwidth=3 " remove unused char at far left
        ]]
          end,
        },
      },
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
        group_empty_dirs = true, -- combines multiple layers of one folder dirs into one entry
        scan_mode = 'deep', -- automatically expand if only one child folder
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- add extension names you want to explicitly exclude
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    }
  end,
}
