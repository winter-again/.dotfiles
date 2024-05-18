; turn of spell check for specific nodes
((inline) @_inline (#lua-match? @_inline "^%s*import")) @nospell
((inline) @_inline (#lua-match? @_inline "^%s*export")) @nospell
