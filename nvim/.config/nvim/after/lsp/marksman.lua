return {
    on_init = function(client)
        if vim.uv.cwd() == vim.fs.normalize("~/Documents/notebook") then
            -- if vim.fs.root(0, ".zk") ~= nil then
            -- disable some capabilities in notes dir to use obsidian/zk instead
            client.server_capabilities.completionProvider = false
            client.server_capabilities.hoverProvider = false
        end
    end,
}
