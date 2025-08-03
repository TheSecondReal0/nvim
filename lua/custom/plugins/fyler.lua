return {
  'A7Lavinraj/fyler.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  branch = 'stable',
  opts = {
    icon_provider = 'nvim-web-devicons',
    close_on_select = false,
    confirm_simple = false,
    views = {
      explorer = {
        kind = 'split:leftmost',
        width = 0.2,
      },
    },
  },
}
