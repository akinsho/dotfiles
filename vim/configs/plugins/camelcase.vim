if !has_key(g:plugs, 'CamelCaseMotion')
  finish
endif

call camelcasemotion#CreateMotionMappings('<leader>')
