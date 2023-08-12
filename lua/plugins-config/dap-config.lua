local dap = require('dap')

dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  args = {vim.fn.stdpath("data") .. "/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js" },
}

dap.configurations.typescriptreact = {
  {
    name = 'Launch Firefox debugger',
    type = 'firefox',
    request = 'launch',
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}/app/javascript/components'
  },
  {
    name = 'Attach Firefox debugger',
    type = 'firefox',
    request = 'attach',
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}/app/javascript/components'
  },
}
require('dap-go').setup({
  dap_configurations = {
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
})


