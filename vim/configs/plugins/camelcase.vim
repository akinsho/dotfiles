if !has_key(g:plugs, 'camelCaseMotion')
  finish
endif

call camelcasemotion#CreateMotionMappings('<leader>')
