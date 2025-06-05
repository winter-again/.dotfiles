;; extends
; inject SQL highlighting into Python strings
(string 
  (string_content) @injection.content
    (#vim-match? @injection.content "^\s*SELECT|FROM|(INNER |LEFT )?JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER|ORDER BY.*$")
    (#set! injection.language "sql")
)
