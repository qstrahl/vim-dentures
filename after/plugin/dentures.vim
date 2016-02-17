"" Default mappings
let s:mappings = [
\  [ 'ii', '<Plug>(InnerDenture)' ],
\  [ 'iI', '<Plug>(InnerDENTURE)' ],
\  [ 'ai', '<Plug>(OuterDenture)' ],
\  [ 'aI', '<Plug>(OuterDENTURE)' ]
\]
 
for [lhs, rhs] in s:mappings
  if !hasmapto(rhs, 'v')
    exe 'vmap <unique>' lhs rhs
  endif
  if !hasmapto(rhs, 'o')
    exe 'omap <unique>' lhs rhs
  endif
endfor
