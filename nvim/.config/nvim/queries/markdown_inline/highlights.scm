;; extends

; conceal latex $ delim
(latex_block (latex_span_delimiter) @conceal (#set! conceal ""))

; markdown links hl + conceal
; (inline_link (link_text) @markup.link.label (link_destination) @markup.link.url)
; ((link_destination) @conceal (#set! conceal ""))
; (inline_link "[" @conceal (#set! conceal ""))
; (inline_link "]" @conceal (#set! conceal ""))
; (inline_link "(" @conceal (#set! conceal ""))
; (inline_link ")" @conceal (#set! conceal ""))

; conceal wikilinks 
; (shortcut_link (link_text) @markup.wikilink.url) @markup.wikilink.label
; (shortcut_link "[" @markup.wikilink.brack_open (#offset! @markup.wikilink.brack_open 0 -1 0 0) (#set! conceal ""))
; (shortcut_link "]" @markup.wikilink.brack_close (#offset! @markup.wikilink.brack_close 0 0 0 1) (#set! conceal ""))
