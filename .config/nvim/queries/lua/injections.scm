; extends
; see: https://github.com/nvim-treesitter/nvim-treesitter/blob/1f087c91f5ca76a2257b855d72d371a2b5302986/queries/lua/injections.scm

(function_call
  name: (dot_index_expression
          field: ((identifier) @_augroup (#any-of? @_augroup "augroup")))
  arguments: (arguments (table_constructor
                          (field name: (identifier) @_cmd  (#any-of? @_cmd "command")
                                 value: (string content: _ @injection.content) (#set! injection.language "vim")))))

; TODO: can this be combined with the query above?
(function_call
  name: ((_) @_augroup (#any-of? @_augroup "augroup"))
  arguments: (arguments (table_constructor
                          (field name: (identifier) @_cmd  (#any-of? @_cmd "command")
                                 value: (string content: _ @injection.content) (#set! injection.language "vim")))))

((function_call
  name: (_) @__cmd
  arguments: (arguments (string content: _ @injection.content)))
  (#set! injection.language "vim")
  (#any-of? @__cmd "cmd"))

; Matches ("%d"):format(value)
(function_call
  (method_index_expression
    table: (parenthesized_expression (string content: _ @injection.content) (#set! injection.language "luap"))
    method: (identifier) @_method))

; Matches fmt("%d", value)
(function_call
  name: (identifier) @_fmt (#any-of? @_fmt "fmt")
  arguments: (arguments (string content: _ @injection.content) (#set! injection.language "luap")))
