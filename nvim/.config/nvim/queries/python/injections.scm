;; extends
; Inject into python SQL queries in multiline strings, assigned to var
; specifically when variable name contains "query"
; this also makes it so that SQL queries inside of python that is
; inside of a markdown fenced code block are also highlighted
(assignment
  left: (identifier) @query_name (#lua-match? @query_name "query")
  right: (string (string_content) @injection.content (#set! injection.language "sql"))
)
