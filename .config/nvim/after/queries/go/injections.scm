; extends
; inject sql into any const string with word query in the name
; e.g. const query = `SELECT * FROM users WHERE name = 'John'`;
(const_spec
  name: (identifier) @_name (#match? @_name "[Q|q]uery$")
  value: (expression_list
    (raw_string_literal) @sql)
    (#offset! @sql 0 1 0 -1))
