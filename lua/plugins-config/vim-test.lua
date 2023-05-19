vim.api.nvim_set_keymap('n', '/n', ':TestNearest<CR>', { silent = true})
vim.api.nvim_set_keymap('n', '/s', ':TestSuite<CR>', { silent = true})
vim.api.nvim_set_keymap('n', '/l', ':TestLast<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '/v', ':TestVisit<CR>', { silent = true})
vim.api.nvim_set_keymap('n', '/f', ':TestFile<CR>', { silent = true})
vim.g.test_javascript_jest_executable = 'yarn tj'

