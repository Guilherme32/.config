-- My Lua Config --------------------------------------------------------------
-- Plugin Manager -------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "adigitoleo/vim-mellow",
    "franbach/miramare",
    "junegunn/seoul256.vim",
    "ribru17/bamboo.nvim",
    "savq/melange-nvim",
    "comfysage/evergarden",
    "zenbones-theme/zenbones.nvim",
    "morhetz/gruvbox",
    "rktjmp/lush.nvim",
    "rebelot/kanagawa.nvim",
    "sainnhe/everforest",
    "projekt0n/caret.nvim",
    "zenbones-theme/zenbones.nvim",
    "mstcl/dmg",
    "echasnovski/mini.base16",

    "folke/which-key.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mhinz/vim-startify",
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",

    "lukas-reineke/indent-blankline.nvim",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
    "mfussenegger/nvim-lint",

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/vim-vsnip",
    "folke/neodev.nvim",

    { "j-hui/fidget.nvim",    tag = "legacy" },
    "mg979/vim-visual-multi",
    "petertriho/nvim-scrollbar",
    "nvim-lualine/lualine.nvim",
    "romgrk/barbar.nvim",

    "simrat39/symbols-outline.nvim",
    "jiangmiao/auto-pairs",
    "kylechui/nvim-surround",
    "tpope/vim-commentary",
    "lewis6991/gitsigns.nvim",
    "ray-x/lsp_signature.nvim",

    "rcarriga/nvim-notify",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",

    { "kiyoon/jupynium.nvim", build = "pip3 install --user ." },
    "kevinhwang91/promise-async",
    "kevinhwang91/nvim-ufo",

    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",

    -- Big ones
    {
        'nvim-orgmode/orgmode',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter', lazy = true },
        },
        event = 'VeryLazy',
        config = function()
            -- Setup treesitter
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { 'org' },
                },
                ensure_installed = { 'org' },
            })

            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/.orgfiles/**/*',
                org_default_notes_file = '~/.orgfiles/refile.org',
            })

            -- Setup custom capture templates
            require('orgmode').setup({
                org_capture_templates = {
                    -- This one pastes a link from the clipboard if there is one
                    r = {
                        description = "Tutorial",
                        template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
                        target = "~/.orgfiles/tutorial.org"
                    }
                }
            })
        end,
    }
})

-- Some useful functions ------------------------------------------------------
local function noremap(mode, keys, action)
    vim.api.nvim_set_keymap(mode, keys, action, { noremap = true, silent = true })
end

-- Theme ----------------------------------------------------------------------
vim.o.termguicolors = true
vim.o.background = "light"
-- vim.cmd.colorscheme("bamboo")
-- vim.cmd.colorscheme("bamboo-multiplex")
vim.cmd.colorscheme("vimbones")
vim.cmd.highlight({ "Folded", "guibg=none", "guifg=#BF472C" })

-- Neovide GUI ----------------------------------------------------------------
if vim.g.neovide then
    vim.o.guifont = "FantasqueSansM Nerd Font:h11"
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_particle_density = 50.0
    vim.g.neovide_cursor_vfx_particle_phase = 5.5
    vim.g.neovide_transparency = 0.95
    vim.g.neovide_floating_blur_amount_x = 9
    vim.g.neovide_floating_blur_amount_y = 6
    vim.g.neovide_remember_window_size = true
    -- vim.g.neovide_profiler = true
end

-- Basic neovim configs -------------------------------------------------------
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.title = true
vim.o.signcolumn = "yes:2"
vim.o.nowrap = true
vim.o.colorcolumn = "80,81,120,150"
vim.o.scrolloff = 10
vim.o.mouse = "a"
vim.o.cursorline = true

vim.o.completeopt = "menuone,noinsert,noselect"
-- vim.o.shortmess += c

noremap("i", "jk", "<ESC>")

-- Treesitter LSP, diagnostics-------------------------------------------------
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "rust", "lua", "python", "markdown", "latex" }
})

require("neodev").setup({})

require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            },
        }
    }
})
require("lspconfig").texlab.setup({})

require("lspconfig").lua_ls.setup({})
require("lspconfig").pylsp.setup({})

require('lint').linters_by_ft = {
    python = { 'ruff', }
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

local signs = { Error = "󰞇 ", Warn = "󰈸", Hint = "󱩠", Info = "󱄷" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        virtual_lines = { only_current_line = true }
    }
)

-- Auto format on saves -----------------
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- LSP related keymaps ------------------
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "diagnostics open float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "next diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "diagnostics set loc list" })

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
vim.keymap.set("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")

-- Autocompletion and snippets ------------------------------------------------
local cmp = require("cmp")
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },

    -- Installed sources
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'orgmode' },
        { name = "jupynium" },
        { name = 'buffer' },
    },
    -- Additional configs
    completion = {
        keyword_length = 0,
    }
})

require("lsp_signature").setup()

-- Which Key - Helper for keybindings -----------------------------------------
vim.o.timeout = true
vim.o.timeoutlen = 500
require("which-key").setup({})

-- Useful trees ---------------------------------------------------------------
require("nvim-tree").setup({
    view = {
        width = 30,
    },
    actions = {
        open_file = {
            quit_on_open = true
        }

    }
})
noremap("n", "tf", "<Cmd>NvimTreeToggle<CR>")
noremap("n", "gtf", "<Cmd>NvimTreeToggle<CR>")

require("symbols-outline").setup({
    position = "left",
    relative_width = false,
    width = 30,
    auto_close = true
})
noremap("n", "ts", "<Cmd>SymbolsOutline<CR>")

-- Indent / non visible characters render -------------------------------------
require("ibl").setup({})
vim.o.list = true

vim.opt.listchars = {
    space = ' ',
    nbsp = ' ',
    trail = '✇',
}

-- Lines ----------------------------------------------------------------------
require("my_lualine")

-- Some helix keybindings -----------------------------------------------------
noremap("n", " p", "\"+p")
noremap("n", " P", "\"+P")
noremap("n", " y", "\"+y")
noremap("n", "U", "<Cmd>redo<CR>")

-- Barbar ---------------------------------------------------------------------
vim.g.barbar_auto_setup = false
require("barbar").setup()
noremap('n', '[b', '<Cmd>BufferPrevious<CR>')
noremap('n', ']b', '<Cmd>BufferNext<CR>')
noremap('n', ' bh', '<Cmd>BufferMovePrevious<CR>')
noremap('n', ' bl', '<Cmd>BufferMoveNext<CR>')
noremap('n', ' b1', '<Cmd>BufferGoto 1<CR>')
noremap('n', ' b2', '<Cmd>BufferGoto 2<CR>')
noremap('n', ' b3', '<Cmd>BufferGoto 3<CR>')
noremap('n', ' b4', '<Cmd>BufferGoto 4<CR>')
noremap('n', ' b5', '<Cmd>BufferGoto 5<CR>')
noremap('n', ' b6', '<Cmd>BufferGoto 6<CR>')
noremap('n', ' b7', '<Cmd>BufferGoto 7<CR>')
noremap('n', ' b8', '<Cmd>BufferGoto 8<CR>')
noremap('n', ' b9', '<Cmd>BufferGoto 9<CR>')
noremap('n', ' b0', '<Cmd>BufferLast<CR>')
noremap('n', ' bp', '<Cmd>BufferPin<CR>')
noremap('n', ' bc', '<Cmd>BufferClose<CR>')
noremap('n', ' bac', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>')
noremap('n', ' bp', '<Cmd>BufferPick<CR>')
noremap('n', ' bon', '<Cmd>BufferOrderByBufferNumber<CR>')
noremap('n', ' bod', '<Cmd>BufferOrderByDirectory<CR>')
noremap('n', ' bol', '<Cmd>BufferOrderByLanguage<CR>')
noremap('n', ' bow', '<Cmd>BufferOrderByWindowNumber<CR>')

-- telescope ------------------------------------------------------------------
local telescope = require('telescope.builtin')

vim.keymap.set('n', ' ff', telescope.find_files, { desc = "telescope files" })
vim.keymap.set('n', ' fg', telescope.live_grep, { desc = "telescope live grep" })
vim.keymap.set('n', ' fb', telescope.buffers, { desc = "telescope buffers" })
vim.keymap.set('n', ' fh', telescope.help_tags, { desc = "telescope help" })

-- Folds / UFO
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 8
vim.o.foldenable = true
vim.o.foldcolumn = "0"
vim.o.foldtext = "getline(v:foldstart).' <><><> '.getline(v:foldend)"
vim.o.fillchars = "fold: "

noremap("n", "z0", "<Cmd>set foldlevel=0<CR>")
noremap("n", "z1", "<Cmd>set foldlevel=1<CR>")
noremap("n", "z2", "<Cmd>set foldlevel=2<CR>")
noremap("n", "z3", "<Cmd>set foldlevel=3<CR>")
noremap("n", "z4", "<Cmd>set foldlevel=4<CR>")
noremap("n", "z5", "<Cmd>set foldlevel=5<CR>")
noremap("n", "z6", "<Cmd>set foldlevel=6<CR>")
noremap("n", "z7", "<Cmd>set foldlevel=7<CR>")
noremap("n", "z8", "<Cmd>set foldlevel=8<CR>")

require("jupynium").get_folds()
require("ufo").setup()

-- Smaller things -------------------------------------------------------------
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_change_to_dir = false
require("scrollbar").setup()
require("fidget").setup()
require("nvim-surround").setup()
require("gitsigns").setup()
require("notify")("Hiiii :)")

vim.cmd.filetype("on")
vim.cmd.filetype("plugin on")

noremap("n", "<S-Tab>", "<C-w>w") -- Quick switch window
