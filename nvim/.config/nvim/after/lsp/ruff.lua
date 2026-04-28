local function get_venv_bin(bin)
    local venv_bin = string.format("./.venv/bin/%s", bin)
    if vim.uv.fs_stat(venv_bin) then
        return venv_bin
    end
    return bin
end

return {
    cmd = { get_venv_bin("ruff"), "server" },
    on_attach = function(client, bufnr)
        -- disable Ruff's hover to use Pyright instead
        client.server_capabilities.hoverProvider = false
    end,
    -- NOTE: server settings here
    -- init_options = {
    --     settings = {},
    -- },
}
