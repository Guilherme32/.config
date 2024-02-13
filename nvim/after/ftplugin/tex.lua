vim.opt.spell = true
vim.opt.spelllang = { "pt_br", "en_us" }

vim.o.textwidth = 79
vim.cmd.colorscheme("mellow")
vim.o.background = "light"

require("lualine").setup({})
require("barbar").setup({})
