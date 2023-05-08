; inherits: typescript

(jsx_element
  (jsx_opening_element
    name: (_) @opening)
  (jsx_closing_element
    name: (_) @closing)) @container

(jsx_self_closing_element
  name: (_) @intermediate) @container
