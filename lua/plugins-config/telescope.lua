local telescope = require('telescope')
local builtin   = require('telescope.builtin')

-- Default setup: ignore node_modules and .git for file pickers
telescope.setup {
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git' },
  },
}

-- File navigation mappings
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Telescope: Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,   { desc = 'Telescope: Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Help Tags' })
