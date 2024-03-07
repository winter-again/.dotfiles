; use extends to to mark queries that should take precedence?
; don't seem to need if the queries are here instead of after/
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

(left_assignment
    (binary
        operator: (special) @pipe (#eq? @pipe "%>%")
) @pipeline) @pipeline_assign
