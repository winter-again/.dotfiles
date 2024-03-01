; from echasnovski
; Queries for R tree-sitter textobjects
; (left_assignment (identifier) (function_definition (formal_parameters) (_) @function.inner )) @function.outer
; (equals_assignment (identifier) (function_definition (formal_parameters) (_) @function.inner )) @function.outer
; (super_assignment (identifier) (function_definition (formal_parameters) (_) @function.inner )) @function.outer

; mine; more explicit so I can remember later
(left_assignment
    name: (identifier)
    value: (function_definition
        (formal_parameters)
        (brace_list) @function.inner
        
    )
) @function.outer
(equals_assignment
    name: (identifier)
    value: (function_definition
        (formal_parameters)
        (brace_list) @function.inner
        
    )
) @function.outer
(super_assignment
    name: (identifier)
    value: (function_definition
        (formal_parameters)
        (brace_list) @function.inner
        
    )
) @function.outer

; capture dplyr pipe operator and the full pipeline
; (binary (_) (_) @op (#eq? @op "%>%")) @pipe
; mine
; captures 3 things: pipeline with assignment, pipeline, and the pipe operator
(left_assignment
    (binary
        operator: (special) @pipe (#eq? @pipe "%>%")
) @pipeline) @pipeline_assign
