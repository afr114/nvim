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
  -- Git utilities
  "tpope/vim-fugitive", -- Git commands in Neovim
  "lewis6991/gitsigns.nvim", -- Git signs
  'vim-test/vim-test',
  -- Commenting
  "tpope/vim-commentary",
  "numToStr/Comment.nvim", -- "gc" to comment visual regions/lines

  -- UI Enhancements
  "nvim-lualine/lualine.nvim",
  "yegappan/mru",
  "folke/neodev.nvim", -- Lua language server config for Neovim
  "metakirby5/codi.vim", -- Interactive scratchpad
  "mg979/vim-visual-multi", -- Multi-cursor support
  "https://github.com/gioele/vim-autoswap", -- Prevent accidental buffer overwrites

  -- Indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = false },
        indent = { enable = true },
      })
    end,
  },

  -- Motion plugin
  {
    "https://github.com/booperlv/nvim-gomove",
    config = function()
      require("gomove").setup({
        map_defaults = false,
        reindent = true,
        undojoin = true,
        move_past_end_col = false,
      })
    end,
  },

  -- LSP, Mason, Completion
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        requires = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
        },
        config = function()
          require("mason").setup()
        end,
      },
    },
  },

  -- Debugging
  { "https://github.com/mfussenegger/nvim-dap" },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = { hijack_netrw_behavior = "disabled" },
      })
    end,
  },

  -- Window Management
  {
    "https://github.com/yorickpeterse/nvim-window",
    config = function()
      require("nvim-window").setup({
        normal_hl = "BlackOnLightYellow",
        hint_hl = "Bold",
        border = "none",
      })
    end,
  },

  -- Colorscheme
  { "neanias/everforest-nvim", branch = "main" },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      -- "saadparwaiz1/cmp_luasnip",
    },
  },

  -- AI-powered completions
  -- {
  --   "milanglacier/minuet-ai.nvim",
  --   config = function()
  --     require("minuet").setup({
  --       provider = "openai_fim_compatible",
  --       n_completions = 1,
  --       context_window = 256,
  --       provider_options = {
  --         openai_fim_compatible = {
  --           api_key = "TERM",
  --           name = "Ollama",
  --           end_point = "http://localhost:11434/v1/completions",
  --           model = "qwen2.5-coder:0.5b",
  --           optional = {
  --             max_tokens = 128,
  --             top_p = 0.7,
  --           },
  --         },
  --       },
  --       virtualtext = {
  --         auto_trigger_ft = {},
  --         keymap = {
  --           accept = "<A-A>",
  --           accept_line = "<A-a>",
  --           accept_n_lines = "<A-z>",
  --           prev = "<A-[>",
  --           next = "<A-]>",
  --           dismiss = "<A-e>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  --
  --
  --
  -- AI powered code understanding and generation
  --
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o",
          extra_request_body = {
            timeout = 30000,
            temperature = 0,
            max_tokens = 4096,
          },
        },
        ollama = {
          model = "qwen2.5-coder:32b",
          stream = true,
          extra_request_body = {
            options = {
              num_keep = 5,
              seed = 42,
              num_predict = 100,
              top_k = 50,
              top_p = 0.9,
              min_p = 0.0,
              typical_p = 0.7,
              repeat_last_n = 128,
              temperature = 0.65,
              repeat_penalty = 1.1,
              presence_penalty = 1.3,
              frequency_penalty = 0.8,
              mirostat = 2,
              mirostat_tau = 5.0,
              mirostat_eta = 0.1,
              penalize_newline = true,
              uma = false,
              num_ctx = 2048,
              num_batch = 4,
              num_gpu = 1,
              main_gpu = 0,
              low_vram = true,
              vocab_only = false,
              use_mmap = true,
              use_mlock = false,
              num_thread = 4,
            },
          },
        },
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  -- {
  --   "xbase-lab/xbase",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("xbase").setup({})
  --   end,
  -- },
  { "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim", -- (optional) to show previews
    "nvim-tree/nvim-tree.lua", -- (optional) to manage project files
    "stevearc/oil.nvim", -- (optional) to manage project files
    "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
  },
  config = function()
    require("xcodebuild").setup({
        -- put some options here or leave it empty to use default settings
    })
  end, 
  },



  { "kelly-lin/telescope-ag", dependencies = { "nvim-telescope/telescope.nvim" } },

  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dim = {},
      -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    -- quickfile = { enabled = true },
    scope = { enabled = true },
    -- scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- zen = {}
  },
  config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)           -- applies your opts.dim (and other snack features)
    end,  
},

  -- Clipboard
  {
    "EtiamNullam/deferred-clipboard.nvim",
    config = function()
      require("deferred-clipboard").setup({
        lazy = true,
        fallback = "unnamedplus",
      })
    end,
  },

  -- Go development
  { "https://github.com/fatih/vim-go" },
  { "https://github.com/leoluz/nvim-dap-go" },

  -- Uncommented plugins re-added at the end
  -- {
  --   "https://github.com/huggingface/llm.nvim",
  --   config = function()
  --     require("llm").setup({
  --       backend = "ollama",
  --       api_token = nil,
  --       model = "qwen2.5-coder:0.5b",
  --       url = "http://localhost:11434/api/generate",
  --       tokens_to_clear = { "<|endoftext|>" },
  --       request_body = {
  --         options = {
  --           temperature = 0.2,
  --           top_p = 0.95,
  --         },
  --       },
  --       fim = {
  --         enabled = true,
  --         prefix = "<fim_prefix>",
  --         middle = "<fim_middle>",
  --         suffix = "<fim_suffix>",
  --       },
  --       debounce_ms = 150,
  --       accept_keymap = "<Tab>",
  --       dismiss_keymap = "<S-Tab>",
  --       tls_skip_verify_insecure = false,
  --       lsp = {
  --         bin_path = nil,
  --         host = nil,
  --         port = nil,
  --         cmd_env = nil, -- or { LLM_LOG_LEVEL = "DEBUG" } for debugging
  --         version = "0.5.3",
  --       },
  --       tokenizer = nil,
  --       context_window = 1024,
  --       enable_suggestions_on_startup = true,
  --       enable_suggestions_on_files = "*",
  --       disable_url_path_completion = false,
  --     })
  --   end,
  -- },
}





require("lazy").setup(plugins, {})
