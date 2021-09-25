; FIXME: disable until https://github.com/vigoux/tree-sitter-viml/issues/29 is fixed
;(
;  (function_call
;    (field_expression (property_identifier) @_cmd_identifier)
;    (arguments (string) @vim)
;  )

;  (#eq? @_cmd_identifier "cmd")
;  (#match? @vim "^[\"']")
;  (#offset! @vim 0 1 0 -1)
;)

;(
;  (function_call
;    (field_expression (property_identifier) @_cmd_identifier)
;    (arguments (string) @vim)
;  )

;  (#eq? @_cmd_identifier "cmd")
;  (#match? @vim "^\\[\\[")
;  (#offset! @vim 0 2 0 -2)
;)
