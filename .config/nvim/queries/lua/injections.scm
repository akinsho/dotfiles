; extends
(function_call
  name: (dot_index_expression
          field: ((identifier) @_augroup (#any-of? @_augroup "augroup")))
  arguments: (arguments (table_constructor
                          (field name: (identifier) @_cmd  (#any-of? @_cmd "command")
                                 value: (string content: _ @injection.content) (#set! injection.language "vim")))))

((function_call
  name: (_) @__cmd
  arguments: (arguments (string content: _ @injection.content)))
  (#set! injection.language "vim")
  (#any-of? @__cmd "cmd"))
