return {
    on_attach = function(client, bufnr)
        -- disable Ruff's hover to use Pyright instead
        client.server_capabilities.hoverProvider = false
    end,
    -- NOTE: server settings here
    -- init_options = {
    --     settings = {},
    -- },
}
