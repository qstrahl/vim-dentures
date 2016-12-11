"" Visual plugin mappings
vnoremap <silent><expr> <Plug>(InnerDenture) dentures#select(line('.'), 0, 0, mode())
vnoremap <silent><expr> <Plug>(InnerDENTURE) dentures#select(line('.'), 0, 1, mode())
vnoremap <silent><expr> <Plug>(OuterDenture) dentures#select(line('.'), 1, 0, mode())
vnoremap <silent><expr> <Plug>(OuterDENTURE) dentures#select(line('.'), 1, 1, mode())

"" Operator plugin mappings
onoremap <silent> <Plug>(InnerDenture) :<C-u>call dentures#select(line('.'), 0, 0, 'operator')<CR>
onoremap <silent> <Plug>(InnerDENTURE) :<C-u>call dentures#select(line('.'), 0, 1, 'operator')<CR>
onoremap <silent> <Plug>(OuterDenture) :<C-u>call dentures#select(line('.'), 1, 0, 'operator')<CR>
onoremap <silent> <Plug>(OuterDENTURE) :<C-u>call dentures#select(line('.'), 1, 1, 'operator')<CR>
