"" Default mappings
let s:mappings = [
\  [ 'id', '<Plug>(InnerDenture)' ],
\  [ 'iD', '<Plug>(InnerDENTURE)' ],
\  [ 'ad', '<Plug>(OuterDenture)' ],
\  [ 'aD', '<Plug>(OuterDENTURE)' ]
\]
 
for [lhs, rhs] in s:mappings
  if !hasmapto(rhs, 'v')
    exe 'vmap <unique>' lhs rhs
  endif
  if !hasmapto(rhs, 'o')
    exe 'omap <unique>' lhs rhs
  endif
endfor
