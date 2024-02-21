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

-- keys for faster development
map("n", "<leader>s", ":w<CR>", {noremap=true, silent=true})
map("n", "<leader>sq", ":wq!<CR>", {noremap=true, silent=true})
map("n", "<leader>q", ":q!<CR>", {noremap=true, silent=true})
-- nvim-ag
vim.api.nvim_set_keymap('n', '<leader>w', ':Ag ', { noremap = true })
-- toggle-term
vim.api.nvim_set_keymap('n', '<leader>t', ':split | terminal<CR>:call feedkeys("i")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>t', ':vsplit | terminal<CR>:call feedkeys("i")<CR>', { noremap = true, silent = true })

--nvim lsp
map('n', '<leader>d', '<cmd>lua vim.lsp.buf.hover()<CR><cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })


