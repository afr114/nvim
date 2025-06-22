local has_words_before = function()
   local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then
        return false
    end
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return not line_text:sub(col, col):match("%s")
end

local luasnip = require("luasnip")
local cmp = require("cmp")

require("lspconfig").sourcekit.setup{
  cmd = {'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'}
}


cmp.setup({

snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    luasnip.lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},


  sources = {
    { name = "minuet"},
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 1 },
  },


  mapping = {
   ['<cr>'] = cmp.mapping.confirm({select = true}),

     ["<up>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

  ["<down>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

	}
})


-- Load the lspconfig module
local nvim_lsp = require('lspconfig')

-- Create a capabilities object to pass to the LSP client with snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- Setup tsserver language server with specified filetypes, root directory, and on_attach function
nvim_lsp.ts_ls.setup{
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  on_attach = function(client, bufnr)
    -- will be called when the language server is attached to a buffer.
    -- This is a good place to put any additional configuration or customization 
    -- that you want to do, specific to this language server.
  end,
}

nvim_lsp.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = nvim_lsp.util.root_pattern("go.work", "go.mod")
}

nvim_lsp.solargraph.setup{
  capabilities = capabilities,
  filtetype = { "ruby"}
}

nvim_lsp.sourcekit.setup{
  on_attach = on_attach,
  cmd = {"xcrun", "sourcekit-lsp"};
  filetypes = {"swift", "c", "cpp", "objc", "objcpp"};
  root_dir = nvim_lsp.util.root_pattern("compile_commands.json", ".git");
  capabilities = capabilities;
}

-- Equivalent of the autocmd for swift files
-- vim.cmd [[
--   autocmd FileType swift autocmd BufWritePost *.swift :silent exec "!swiftformat %"
-- ]]

-- Enable completion for TypeScript and JavaScript
vim.cmd("autocmd FileType typescript,javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc")
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
--
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable signs
    signs = true,
    -- Enable virtual text
    virtual_text = true,
    -- Show line diagnostics on hover
    update_in_insert = false,
  }
)


