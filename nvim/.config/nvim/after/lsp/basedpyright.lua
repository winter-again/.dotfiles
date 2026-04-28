local function get_venv_bin(bin)
    local venv_bin = string.format("./.venv/bin/%s", bin)
    if vim.uv.fs_stat(venv_bin) then
        return venv_bin
    end
    return bin
end

return {
    cmd = { get_venv_bin("basedpyright-langserver"), "--stdio" },
    settings = {
        basedpyright = {
            -- see settings: https://github.com/microsoft/pyright/blob/54f7da25f9c2b6253803602048b04fe0ccb13430/docs/settings.md
            disableOrganizeImports = true, -- use Ruff instead
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                autoImportCompletions = false,
                diagnosticSeverityOverrides = {
                    reportUndefinedVariable = "none",
                },
            },
        },
    },
}
