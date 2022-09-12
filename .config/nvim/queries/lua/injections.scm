; extends
(function_call
  name: (dot_index_expression
          field: ((identifier) (#match? "augroup")))
  arguments: (arguments
        (table_constructor
          (field
            value: (table_constructor
                     (field
                       name: (identifier) @ident (#match? @ident "command")
                       value: (string) @vim (#offset! @vim 0 1 0 -1)))))))
