local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

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
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5 },
  },


    


  -- mapping = {
  --  ['<CR>'] = cmp.mapping.confirm({select = true})

    -- ... Your other mappings ...
  --[[
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    --]]
    
--[[
-- When the Up arrow key is pressed
["<Up>"] = cmp.mapping(function(fallback)
  -- If the completion menu is visible
  if cmp.visible() then
    -- Select the previous suggestion in the menu
    cmp.select_prev_item()
  -- If the current snippet is jumpable
  elseif luasnip.jumpable(-1) then
    -- Jump to the previous placeholder in the snippet
    luasnip.jump(-1)
  else
    -- Use the default behavior (insert a tab character)
    fallback()
  end
end, { "i", "s" }),

-- When the Down arrow key is pressed
["<Down>"] = cmp.mapping(function(fallback)
  -- If the completion menu is visible
  if cmp.visible() then
    -- Select the next suggestion in the menu
    cmp.select_next_item()
  -- If the current snippet is expandable or jumpable
  elseif luasnip.expand_or_jumpable() then
    -- Expand the snippet or jump to the next placeholder
    luasnip.expand_or_jump()
  -- If there are words before the cursor
  elseif has_words_before() then
    -- Show completion suggestions
    cmp.complete()
  else
    -- Use the default behavior (insert a tab character)
    fallback()
  end
end, { "i", "s" }),
    --]]
    -- ... Your other mappings ...
  -- },

  -- ... Your other configuration ...

})


-- Load the lspconfig module
local nvim_lsp = require('lspconfig')

-- Create a capabilities object to pass to the LSP client with snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- Setup tsserver language server with specified filetypes, root directory, and on_attach function
nvim_lsp.tsserver.setup{
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  on_attach = function(client, bufnr)
    -- will be called when the language server is attached to a buffer.
    -- This is a good place to put any additional configuration or customization 
    -- that you want to do, specific to this language server.
  end,
}


