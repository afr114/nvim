-- Neovim LSP configuration (lua/lsp.lua)
-- Focused on definitions, autocomplete, and full LSP mappings.

-- Utility: detect if there are words before the cursor (for cmp Tab completion)
local has_words_before = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  return not line:sub(col, col):match('%s')
end

-- Snippet engine and completion
local cmp     = require('cmp')
local luasnip = require('luasnip')
local util = require('lspconfig.util')

cmp.setup {
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<CR>']      = cmp.mapping.confirm { select = true },
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>']     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' }, { name = 'luasnip' },
    { name = 'buffer'    }, { name = 'path'    },
  },
}

-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- on_attach: run when an LSP server attaches to a buffer
local on_attach = function(client, bufnr)
  -- Enable omnifunc for completion
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { noremap=true, silent=true, buffer=bufnr }
  -- Definitions, declarations, implementation, references
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,  opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,   opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,   opts)

  -- Hover and signature help
  vim.keymap.set('n', 'K',     vim.lsp.buf.hover,          opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

  -- Workspace folders
  vim.keymap.set('n', '<space>wa', function() vim.lsp.buf.add_workspace_folder() end, opts)
  vim.keymap.set('n', '<space>wr', function() vim.lsp.buf.remove_workspace_folder() end, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  -- Type definition, rename, code actions
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,         opts)
  vim.keymap.set({'n','v'}, '<space>ca', vim.lsp.buf.code_action, opts)

  -- Formatting
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
end

-- Diagnostics display
vim.diagnostic.config {
  virtual_text     = { prefix = '●', spacing = 2 },
  signs            = true,
  update_in_insert = false,
}

-- LSP servers setup
local lspconfig = require('lspconfig')

-- TypeScript / JavaScript (ts_ls)
lspconfig.ts_ls.setup {
  on_attach    = on_attach,
  capabilities = capabilities,
  filetypes    = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir     = lspconfig.util.root_pattern('package.json', 'tsconfig.json', '.git'),
}

-- Go (gopls)
lspconfig.gopls.setup {
  on_attach    = on_attach,
  capabilities = capabilities,
}

-- Ruby (Solargraph)
-- Ruby (Solargraph)
--
lspconfig.solargraph.setup {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/solargraph", "stdio" },
  on_attach    = on_attach,
  capabilities = capabilities,
  root_dir     = util.root_pattern("Gemfile.local", "Gemfile", ".git"),
  settings     = {
    solargraph = {
      diagnostics = {
        rubocop = { enabled = false } -- avoid rubocop-related load errors
      }
    }
  },
  filetypes    = { "ruby" }
}

-- Swift / C / C++ / Objective-C (sourcekit)
lspconfig.sourcekit.setup {
  on_attach    = on_attach,
  capabilities = capabilities,
  filetypes    = { 'swift', 'c', 'cpp', 'objc', 'objcpp' },
  cmd          = { 'xcrun', 'sourcekit-lsp' },
  root_dir     = lspconfig.util.root_pattern('compile_commands.json', '.git'),
}

-- Postgres (postgrestools proxy)
if not require('lspconfig.configs').postgrestools then
  require('lspconfig.configs').postgrestools = {
    default_config = {
      cmd                = { 'postgrestools', 'lsp-proxy' },
      filetypes          = { 'sql' },
      root_dir           = lspconfig.util.root_pattern('postgrestools.jsonc', '.git'),
      single_file_support= true,
    },
  }
end
lspconfig.postgres_lsp.setup {
  on_attach    = on_attach,
  capabilities = capabilities,
}
