;; extends

; define code block components as textobjects
(fenced_code_block
    (info_string (language) @codeblock.lang)
    (code_fence_content) @codeblock.inner
) @codeblock.outer
