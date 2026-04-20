return {
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
