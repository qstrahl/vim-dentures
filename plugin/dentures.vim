if exists('g:loaded_dentures')
    finish
endif

let g:loaded_dentures = 1

"" Return 1 if line "line" is blank, else 0
function! s:blank (line)
    return getline(a:line) =~ '\v^\s*$'
endfunction

"" Return last line from "start" in direction "step" to match "match" before line matching "stop" given "vars", else 0
function! s:lastline (start, step, match, stop, vars)
    "" Special case: if step is 0, first try forward, then backward
    if a:step == 0
        let l:line = s:lastline(a:start, 1, a:match, a:stop, a:vars)

        return l:line ? l:line : s:lastline(a:start, -1, a:match, a:stop, a:vars)
    endif

    let l:previndent = 0
    let l:prevline = 0
    let l:prevblank = 0
    let l:line = a:start
    let l:indent = indent(l:line)
    let l:match = 0

    "" Transclude a:vars into l: scope
    for l:item in items(a:vars)
       let l:[l:item[0]] = l:item[1]
    endfor

    "" Loop until first or last line, depending on direction
    while l:line >= 1 && l:line <= line('$')
        if !s:blank(l:line)
            let l:indent = indent(l:line)
            let l:blank = 0
        else
            let l:blank = 1
        endif

        if eval(a:stop)
            break
        endif

        if eval(a:match)
            let l:match = l:line
        endif

        let l:prevline = l:line
        let l:prevblank = l:blank
        let l:previndent = l:indent
        let l:line += a:step
    endwhile

    return l:match
endfunction

"" Return a nonblank line number near line "line", searching forward first, then backward if necessary
function! s:findnonblank (line)
    let l:match = 'l:line != a:start && !l:blank'
    let l:stop = 'l:line != a:start && !l:prevblank'
    let l:line = s:blank(a:line) ? s:lastline(a:line, 0, l:match, l:stop, {}) : a:line

    return l:line
endfunction

"" Return a pair of lines defined by "start", "match", and "stop"
function! s:denture (start, match, stop)
    let l:line = s:findnonblank(a:start)
    let l:iindent = indent(l:line) " initial indent

    let l:vars = { 'iindent': l:iindent, 'eol': 0 }
    
    let l:last = s:lastline(l:line, 1, a:match, a:stop, l:vars)
    let l:last = l:last ? l:last : line('$')

    let l:vars.eol = l:last == line('$')

    let l:first = s:lastline(l:line, -1, a:match, a:stop, l:vars)
    let l:first = l:first ? l:first : 1

    return [l:first, l:last]
endfunction

"" Return line range surrounding "start", indented >= "start", and delimited by blank lines
function! s:ii (start)
    let l:match = '!l:blank && l:indent >= l:iindent'
    let l:stop = '!l:blank && l:prevblank && l:indent <= l:iindent'
    return s:denture(a:start, l:match, l:stop)
endfunction

"" Return line range surrounding "start" and indented >= "start", ignoring blank lines
function! s:iI (start)
    let l:match = '!l:blank && l:indent >= l:iindent'
    let l:stop = 'l:indent < l:iindent'
    return s:denture(a:start, l:match, l:stop)
endfunction

"" Return line range surrounding "start", indented >= "start", and delimited by blank lines, plus trailing blank lines
function! s:ai (start)
    let l:match = '(a:step > 0 || l:eol || !l:blank) && l:indent >= l:iindent'
    let l:stop = '!l:blank && l:prevblank && l:indent <= l:iindent'
    return s:denture(a:start, l:match, l:stop)
endfunction

"" Return line range surrounding "start" and indented >= "start", ignoring blank lines, plus trailing blank lines
function! s:aI (start)
    let l:match = 'l:indent >= l:iindent'
    let l:stop = 'l:indent < l:iindent'
    return s:denture(a:start, l:match, l:stop)
endfunction

"" Select denture "denture" from line "start" with visual mode "mode"
function! s:select (denture, start, mode)
    let l:lines = function('s:' . a:denture)(a:start)
    let l:first = l:lines[0]
    let l:last = l:lines[1]

    call cursor(l:first, 1)
    if a:mode == "\<C-V>"
        exe 'normal! ^'
    endif
    exe 'normal!' a:mode
    call cursor(l:last, 1)
    exe "normal! \<Esc>"
    normal! gv$
endfunction

onoremap <silent> <Plug>(InnerDenture) :<C-U>call <SID>select('ii', line('.'), "V")<CR>
onoremap <silent> <Plug>(InnerDENTURE) :<C-U>call <SID>select('iI', line('.'), "V")<CR>
vnoremap <silent> <Plug>(InnerDenture) :<C-U>call <SID>select('ii', line('.'), visualmode())<CR>
vnoremap <silent> <Plug>(InnerDENTURE) :<C-U>call <SID>select('iI', line('.'), visualmode())<CR>

onoremap <silent> <Plug>(ADenture) :<C-U>call <SID>select('ai', line('.'), "V")<CR>
onoremap <silent> <Plug>(ADENTURE) :<C-U>call <SID>select('aI', line('.'), "V")<CR>
vnoremap <silent> <Plug>(ADenture) :<C-U>call <SID>select('ai', line('.'), visualmode())<CR>
vnoremap <silent> <Plug>(ADENTURE) :<C-U>call <SID>select('aI', line('.'), visualmode())<CR>

omap <silent> ii <Plug>(InnerDenture)
omap <silent> iI <Plug>(InnerDENTURE)
vmap <silent> ii <Plug>(InnerDenture)
vmap <silent> iI <Plug>(InnerDENTURE)

omap <silent> ai <Plug>(ADenture)
omap <silent> aI <Plug>(ADENTURE)
vmap <silent> ai <Plug>(ADenture)
vmap <silent> aI <Plug>(ADENTURE)