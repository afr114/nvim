-- add lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'tpope/vim-fugitive', -- git commands in neovim
  'tpope/vim-commentary',
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines,
  'nvim-lualine/lualine.nvim',
  'lewis6991/gitsigns.nvim',
  'vim-test/vim-test',
  'yegappan/mru',
  'https://github.com/gioele/vim-autoswap',
  'folke/neodev.nvim', -- Lua language server configuration for nvim
  'metakirby5/codi.vim',
  { "lukas-reineke/indent-blankline.nvim", 
    config = function() require("ibl").setup() end, main = "ibl", opts = {} 
  },
  { "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup({
          highlight = {
            enable = false
          },
          indent = {
            enable = true
          }
        })
      end,
  },
  { "https://github.com/booperlv/nvim-gomove",
     config = function()
      require("gomove").setup({
    -- whether or not to map default key bindings, (true/false)
    map_defaults = false,
    -- whether or not to reindent lines moved vertically (true/false)
    reindent = true,
    -- whether or not to undojoin same direction moves (true/false)
    undojoin = true,
    -- whether to not to move past end column when moving blocks horizontally, (true/false)
    move_past_end_col = false,
    })
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        requires = {
        --  {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'hrsh7th/cmp-cmdline'},
         -- {'L3MON4D3/LuaSnip'},
         -- {'hrsh7th/nvim-cmp'},
        },
        config = function()
          require("mason").setup()
        end,
      },
    },
  },
  {
    "https://github.com/mfussenegger/nvim-dap"
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
      config = function()
        require("neo-tree").setup({
          filesystem = {
            hijack_netrw_behavior = "disabled",
          }
        })
      end,
  },
  {
    "https://github.com/yorickpeterse/nvim-window",
    config = function()
      require('nvim-window').setup({
       normal_hl = 'BlackOnLightYellow',
    hint_hl = 'Bold',
    border = 'none'
  })
    end
  },
  {
   'neanias/everforest-nvim',
    branch = 'main'
  },
  { -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
      build = 'make',
  },  
  {
      'xbase-lab/xbase',
      dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
      config = function() 
        require('xbase').setup({}) 
      end,     
  },
  {
      "kelly-lin/telescope-ag",
      dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "EtiamNullam/deferred-clipboard.nvim",
     config = function() 
    require('deferred-clipboard').setup({
    lazy = true,
    fallback = 'unnamedplus'
    })
     end,
  },
  { "https://github.com/fatih/vim-go" },
  { "https://github.com/leoluz/nvim-dap-go"},
  -- {
  -- "https://github.com/ggandor/leap.nvim",
  --   config = function()
  --     local leap = require('leap')
  --     -- Set up custom mappings
  --     vim.api.nvim_set_keymap('n', '<Space>s', '<Plug>(leap-forward-to)', { noremap = true, silent = true })
  --     vim.api.nvim_set_keymap('n', '<Space>S', '<Plug>(leap-backward-to)', { noremap = true, silent = true })
  --     -- Add any other custom mappings as needed
  --   end,
  -- }

}






require("lazy").setup(plugins, {})
