local map = vim.api.nvim_set_keymap

map('n', '<leader><tab>', ":lua require('nvim-window').pick()<CR>", {silent=true})
map('n', '<space>m', '<cmd>MRU<CR>', {noremap = true})

map("n", "<C-S-Left>", "<Plug>GoNSMLeft", {})
map("n", "<C-S-Down>", "<Plug>GoNSMDown", {})
map("n", "<C-S-Up>", "<Plug>GoNSMUp", {})
map("n", "<C-S-Right>", "<Plug>GoNSMRight", {})

map("x", "<C-S-Left>", "<Plug>GoVSMLeft", {})
map("x", "<C-S-Down>", "<Plug>GoVSMDown", {})
map("x", "<C-S-Up>", "<Plug>GoVSMUp", {})
map("x", "<C-S-Right>", "<Plug>GoVSMRight", {})


