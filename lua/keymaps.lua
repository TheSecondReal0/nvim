-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- toggle neo-tree with \, show with |
vim.keymap.set('n', '\\', ':Neotree toggle current reveal_force_cwd<cr>', { desc = 'Toggle neo-tree reveal' })
vim.keymap.set('n', '|', ':Neotree reveal<cr>', { desc = 'Reveal neo-tree' })

-- don't yank on deletes
-- Map 'd' to delete to the black hole register "_d
vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true, silent = true })
-- don't yank from visual mode
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true })
vim.keymap.set('v', 'x', '"_x', { noremap = true, silent = true })

-- bind redo to U
vim.keymap.set('n', 'U', '<C-R>', { noremap = true, silent = true })

-- compiler maps
-- Open compiler
vim.api.nvim_set_keymap('n', '<F6>', '<cmd>CompilerOpen<cr>', { noremap = true, silent = true })

-- Redo last selected option
vim.api.nvim_set_keymap(
  'n',
  '<S-F6>',
  '<cmd>CompilerStop<cr>' -- (Optional, to dispose all tasks before redo)
    .. '<cmd>CompilerRedo<cr>',
  { noremap = true, silent = true }
)

-- Toggle compiler results
vim.api.nvim_set_keymap('n', '<S-F7>', '<cmd>CompilerToggleResults<cr>', { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
