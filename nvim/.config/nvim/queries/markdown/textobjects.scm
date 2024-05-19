; define code blocks as textobj
(code_fence_content) @block.inner

(fenced_code_block
    (info_string (language) @block.lang)
) @block.outer
