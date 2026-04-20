return {
    settings = {
        gopls = {
            semanticTokens = true,
            analyses = {
                -- see https://github.com/golang/tools/blob/3e7f74d009150bf5e66483f3759d8c59f50e873d/gopls/doc/analyzers.md
                -- these might all be on by default?
                nilness = true, -- reports nil pointer issues
                shadow = true, -- shadowed vars
                unusedparams = true, -- checks for unused params of funcs
                unusedwrite = true, -- instances of writes to struct fields or arrays that are never read
                useany = true,
            },
            hints = {
                -- for inlay hints
                -- see https://go.googlesource.com/tools/+/4d205d81b5a0f7cb051584b8964b7a0fd6d502c2/gopls/doc/inlayHints.md
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}
