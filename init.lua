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


_G.checkSwiftFile = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- Clear existing virtual text
  vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

  -- Run swiftc
  local result = vim.fn.system("swiftc -typecheck " .. filename)
  
  print("swiftc output:", result) -- Print the command output for debugging
  

  
  for _, line in ipairs(vim.fn.split(result, "\n")) do
    -- Match the compiler's output format. This regex might need adjustments.

    
    local match = vim.fn.matchlist(line, "\\(.*\\.swift\\):\\(\\d+\\):\\d+: error: \\(.*\\)")
    print(#match)
for _, v in ipairs(match) do
  print(v)
end

  if #match > 0 then
      print('APPPLE')
      local lnum = tonumber(match[2])
      print("Line number:", lnum)
      local message = match[4]
      print("Matched:", lnum, message)  -- Print the matched line number and message for debugging
      vim.api.nvim_buf_set_virtual_text(bufnr, 0, lnum - 1, {{message, "WarningMsg"}}, {})
      vim.api.nvim_buf_set_virtual_text(bufnr, 0, lnum - 1, {{match[4], "Error"}}, {})
    end
  end

end

vim.cmd("command! SwiftCheck lua checkSwiftFile()")

