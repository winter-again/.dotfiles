; extends

; Inject some JS/JSX highlights into markdown/mdx
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "typescript")
)

((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injections.language "typescript")
)
