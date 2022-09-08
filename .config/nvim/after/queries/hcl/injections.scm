; extends
(function_call
  ((identifier) (#match? "yamldecode")
  (function_arguments
    (expression
      (template_expr
        (heredoc_template
          (template_literal)  @yaml))))))
