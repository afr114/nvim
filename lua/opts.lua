local opt = vim.opt

local default_options = {
    autoindent = true,
    backup = false, -- creates a backup file
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight = 1, -- more space in the neovim command line for displaying messages
    colorcolumn = "80",
    completeopt = { "menuone", "noselect" },
    conceallevel = 0, -- so that `` is visible in markdown files
    cursorline = false, -- highlight the current line
    expandtab = true, -- convert tabs to spaces
    fileencoding = "utf-8", -- the encoding written to a file
    foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
    guicursor = "a:block-nCursor-blinkon1",
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    incsearch = true,
    laststatus = 3,      
    mouse = "a", -- allow the mouse to be used in neovim
    number = true, -- set numbered lines
    numberwidth = 4, -- set number column width to 2 {default 4}
    pumheight = 10, -- pop up menu height
    relativenumber = false,
    ruler = false,
    scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
    shiftwidth = 2, -- the number of spaces inserted for each indentation
    showcmd = true,
    showmode = true, -- we need to see things like -- INSERT -- anymore
    sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.
    signcolumn = "yes",
    smartcase = true, -- smart case
    smartindent = true,
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    tabstop = 2, -- insert 2 spaces for a tab
    termguicolors = false,
    timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
    title = true, -- set the title of window to the value of the titlestring
    titlestring = "%<%F%=%l/%L - nvim", -- what the title of the window will be set to
    undodir = vim.fn.stdpath "cache" .. "/undo", -- set an undo directory
    undofile = true, -- enable persistent undo
    updatetime = 100, -- faster completion
    wrap = false, -- display lines as one long line
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  }

for k, v in pairs(default_options) do
   opt[k] = v
end

