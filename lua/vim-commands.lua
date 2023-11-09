vim.cmd('highlight CursorLine guifg=NONE guibg=#2d3c45 ctermbg=237 gui=NONE term=NONE cterm=NONE')
vim.cmd([[colorscheme everforest]])
vim.cmd('hi BlackOnLightYellow guifg=#000000 guibg=#f2de91')


-- Equivalent of 'set autoread'
vim.o.autoread = true

-- Equivalent of the autocmd for swift files
vim.cmd [[
  autocmd FileType swift autocmd BufWritePost *.swift :silent exec "!swiftformat %"
]]
