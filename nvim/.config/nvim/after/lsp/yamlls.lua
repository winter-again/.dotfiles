return {
    on_attach = function(client, bufnr)
        -- NOTE: yamlls includes formatting capabilities; disable it, though
        -- it doesn't seem to work anyway?
        -- client.server_capabilities.documentFormattingProvider = false
    end,
}
