;; extends

; Use typst highlighting for math content in markdown
; See https://github.com/OXY2DEV/markview.nvim/issues/422
; setting priority might help with consistent application, though its value isn't reflected in Inspect?
((latex_block) @injection.content
  ; (#set! priority 105)
  (#set! injection.language "typst")
  (#set! injection.include-children))
