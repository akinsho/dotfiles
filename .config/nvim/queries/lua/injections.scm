; extends
(function_call
  name: (dot_index_expression
          field: ((identifier) (#lua-match? "augroup")))
  arguments: (arguments
       (table_constructor
          (field
            name: (identifier) @ident (#lua-match? @ident "command")
            value: (string) @vim (#offset! @vim 0 1 0 -1)))))
