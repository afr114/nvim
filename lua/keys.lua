local map = vim.api.nvim_set_keymap

--nvim window
map('n', '<leader><tab>', ":lua require('nvim-window').pick()<CR>", {silent=true})

-- nvim mru
map('n', '<space>m', '<cmd>MRU<CR>', {noremap = true})

-- nvim-go
map("n", "<C-S-Left>", "<Plug>GoNSMLeft", {})
map("n", "<C-S-Down>", "<Plug>GoNSMDown", {})
map("n", "<C-S-Up>", "<Plug>GoNSMUp", {})
map("n", "<C-S-Right>", "<Plug>GoNSMRight", {})

map("x", "<C-S-Left>", "<Plug>GoVSMLeft", {})
map("x", "<C-S-Down>", "<Plug>GoVSMDown", {})
map("x", "<C-S-Up>", "<Plug>GoVSMUp", {})
map("x", "<C-S-Right>", "<Plug>GoVSMRight", {})

-- nvim-ag
vim.api.nvim_set_keymap('n', '<leader>w', ':Ag ', {noremap = true})

