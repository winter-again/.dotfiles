; relink these nodes to what's described here: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#markup
(atx_heading (atx_h1_marker) @markup.heading.1.marker (inline) @markup.heading.1)
(atx_heading (atx_h2_marker) @markup.heading.2.marker (inline) @markup.heading.2)
(atx_heading (atx_h3_marker) @markup.heading.3.marker (inline) @markup.heading.3)
(atx_heading (atx_h4_marker) @markup.heading.4.marker (inline) @markup.heading.4)
(atx_heading (atx_h5_marker) @markup.heading.5.marker (inline) @markup.heading.5)
(atx_heading (atx_h6_marker) @markup.heading.6.marker (inline) @markup.heading.6)

((block_quote) @markup.quote)

; enable spell checking
(inline) @spell
; turn off spell check for specific nodes
((inline) @_inline (#lua-match? @_inline "^%s*import")) @nospell
((inline) @_inline (#lua-match? @_inline "^%s*export")) @nospell

; code blocks
(fenced_code_block
    (info_string (language) @codeblock.lang)
    (code_fence_content) @codeblock.inner
) @codeblock.outer

; target checked checkbox line and sub items separately
(list_item (task_list_marker_checked) @markup.list.checkbox.checked (paragraph (inline) @markup.list.checked) (#eq? @markup.list.checkbox.checked "[x]")) @markup.list.checked_item

; checkbox: conceal both minus sign and the actual checkbox
; ((task_list_marker_unchecked)
;  @text.todo.unchecked
;  (#offset! @text.todo.unchecked 0 -2 0 0)
;  (#set! conceal "󰄱"))
;
; ((task_list_marker_checked)
;  @text.todo.checked
;  (#offset! @text.todo.checked 0 -2 0 0)
;  (#set! conceal ""))

; currently doesn't work perf: first sub-item is concealed incorrectly b/c of whitespace
; see: https://github.com/tree-sitter-grammars/tree-sitter-markdown/issues/127
; (
;     (list_marker_minus) @markdown_list_marker
;     (#offset! @markdown_list_marker 0 0 0 -1)
;     (#set! conceal "•")
; )

; (setext_heading (setext_h1_underline) @markup.heading.1.marker)
; (setext_heading (setext_h2_underline) @markup.heading.2.marker)
