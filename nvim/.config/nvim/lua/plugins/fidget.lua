return {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
    enabled = false,
    config = function()
        require('fidget').setup({
            text = {
                spinner = 'dots'
            },
            window = {
                blend = 0
            }
        })
    end
}
