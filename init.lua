-- disable netrw 
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.modifiable = true

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
-- vim.g.localleader = "\\"

-- IMPORTS

   require('plugin_manager')      -- Plugins
   require('plugins-config')
   require('vars')      -- Variables
   require('opts')      -- Options
   require('keys')      -- Keymaps
   require('vim-commands') -- calls to vim
