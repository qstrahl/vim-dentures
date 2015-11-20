"" Visual plugin mappings
vnoremap <silent><expr> <Plug>(InnerDenture) dentures#select(line('.'), 0, 0, mode())
vnoremap <silent><expr> <Plug>(InnerDENTURE) dentures#select(line('.'), 0, 1, mode())
vnoremap <silent><expr> <Plug>(OuterDenture) dentures#select(line('.'), 1, 0, mode())
vnoremap <silent><expr> <Plug>(OuterDENTURE) dentures#select(line('.'), 1, 1, mode())

"" Operator plugin mappings
onoremap <silent><expr> <Plug>(InnerDenture) dentures#select(line('.'), 0, 0, 'V')
onoremap <silent><expr> <Plug>(InnerDENTURE) dentures#select(line('.'), 0, 1, 'V')
onoremap <silent><expr> <Plug>(OuterDenture) dentures#select(line('.'), 1, 0, 'V')
onoremap <silent><expr> <Plug>(OuterDENTURE) dentures#select(line('.'), 1, 1, 'V')
