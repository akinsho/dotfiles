(function_call
  ((identifier) (#match? "yamldecode")
  (function_arguments
    (expression
      (template_expr
        (heredoc_template
          (template_literal)  @yaml))))))

; FIXME: this attemps to match the language up till "decode" and use that to
; dynamically inject the language
; (function_call
;   (((identifier) @language (#lua-match? @language "(.-)decode"))
;   (function_arguments
;     (expression
;       (template_expr
;         (heredoc_template
;           (template_literal)  (#set! "language" @language)))))))
