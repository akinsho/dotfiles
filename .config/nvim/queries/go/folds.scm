(composite_literal) @fold

; Attempt to fold literal structs inside of a slice
; []Test{
;   {
;     Value: "item",
;     Value2: 2,
;   },
; }
; (composite_literal
;   type: (slice_type)
;   body: (literal_value (literal_element ((literal_value) @capture))))

