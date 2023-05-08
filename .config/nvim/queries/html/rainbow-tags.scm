;; A pair of opening and closing tag with any content in-between. Excludes
;; self-closing tags or opening tags without closing tag.

(element
  (start_tag
    (tag_name) @opening)
  (end_tag
    (tag_name) @closing)) @container

(style_element
  (start_tag
    (tag_name) @opening)
  (end_tag
    (tag_name) @closing)) @container

(script_element
  (start_tag
    (tag_name) @opening)
  (end_tag
    (tag_name) @closing)) @container

(self_closing_tag
  (tag_name) @intermediate) @container
