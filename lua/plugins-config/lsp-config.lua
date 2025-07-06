local has_words_before = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line, col = pos[1], pos[2]

  if col == 0 then
    return false
  end

  local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return not line_text:sub(col, col):match("%s")
end

local luasnip = require("luasnip")
local cmp = require("cmp")

-- Default on_attach function
local on_attach = function(client, bufnr)
  -- Add buffer-local keymaps or customizations here
end

-- Setup nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  sources = {
    { name = "minuet" },
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 1 },
  },

  mapping = {
    ["<cr>"] = cmp.mapping.confirm({ select = true }),

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
  },
})

-- LSP setup
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Register Postgres Language Server (for older lspconfig versions)
if not configs.postgrestools then
  configs.postgrestools = {
    default_config = {
      cmd = { "postgrestools", "lsp-proxy" },
      filetypes = { "sql" },
      root_dir = lspconfig.util.root_pattern("postgrestools.jsonc", ".git"),
      single_file_support = true,
    },
  }
end

-- Use built-in if available
lspconfig.postgres_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript / JavaScript
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod"),
})

-- Ruby
lspconfig.solargraph.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "ruby" },
})

-- Swift / C / C++ / Objective-C
lspconfig.sourcekit.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift", "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
})

-- Enable omnifunc for TypeScript and JavaScript
vim.cmd("autocmd FileType typescript,javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc")

-- Global diagnostic keymaps
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- LspAttach autocmd to set buffer-local keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Diagnostic display settings
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    signs = true,
    virtual_text = true,
    update_in_insert = false,
  }
)

