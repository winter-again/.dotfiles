return {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-treesitter/nvim-treesitter' -- need markdown and markdown_inline parsers
    },
    config = function()
        require('lspsaga').setup({
            ui = {
                border = 'rounded'
            },
            symbol_in_winbar = {
                enable = false
            },
            lightbulb = {
                enable = false -- disable code actions lightbulb icon
            },
            scroll_preview = {
                scroll_down = '<C-f>',
                scroll_up = '<C-b>'
            }
        })
        local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, {desc=desc, silent=true})
        end
        -- hover docs; doesn't auto focus
        nmap('K', '<cmd>Lspsaga hover_doc<CR>', 'Hover docs')
        -- hover diagnostics; ++unfocus to not autofocus
        nmap('gs', '<cmd>Lspsaga show_cursor_diagnostics ++unfocus<CR>', 'Cursor diagnostics')
        -- show line diagnostics
        nmap('gl', '<cmd>Lspsaga show_line_diagnostics<CR>', 'Line diagnostics')
        -- finder that shows defn, ref, and implementation
        nmap('gf', '<cmd>Lspsaga lsp_finder<CR>', 'LSP finder')
        -- peeks defn and focuses the window; can use q to get back to main buffer
        nmap('gd', '<cmd>Lspsaga peek_definition<CR>', 'Peek defn.')
        -- not always supported by the LSP
        nmap('gi', vim.lsp.buf.implementation, 'Go to implementation')
        -- peeks type defn and focuses window
        nmap('gt', '<cmd>Lspsaga peek_type_definition<CR>', 'Peek type defn.')
        -- searches the references in Telescope so you can jump to selection
        nmap('gr', require('telescope.builtin').lsp_references, 'Go to refs.')
        -- rename all references to symbol under cursor
        nmap('<leader>rn', '<cmd>Lspsaga rename<CR>', 'Rename in file')
    end
}
