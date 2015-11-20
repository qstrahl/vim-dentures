"" Find the line nearest to "line" for which "expr" is true
function! dentures#nearest (line, expr, ...)
    "" Optional third argument determines how we increment the line number we're looking at
    let l:inc = a:0 < 1 ? 1 : a:1

    "" It also determines if we look both ways; if omitted, we look both ways
    let l:reverse = a:0 < 1 ? 1 : 0

    "" Optional fourth argument determines what value to return if we find nothing
    let l:default = a:0 < 2 ? 0 : a:2

    "" Current line being examined
    let l:line = a:line

    "" Line at which we should stop looking (first or last)
    let l:stop = l:inc > 0 ? line('$') + 1 : 0

    "" Current indent level (we'll initialise it for real later)
    let l:indent = 0

    "" Indent level of the first line we're given
    let l:firstIndent = indent(a:line)

    "" Go until it's time to stop
    while l:line != l:stop
        "" Compute helpful values for a:expr to use
        let l:empty = empty(getline(l:line))
        let l:indent = l:empty ? l:indent : indent(l:line)
        let l:lower = l:indent < l:firstIndent
        let l:equal = l:indent == l:firstIndent
        if eval(a:expr)
            return l:line
        endif
        let l:line += l:inc
    endwhile

    "" If we get here, a:expr never eval'd true. Reverse if we should, otherwise give up and return default
    return l:reverse ? dentures#nearest(a:line, a:expr, -l:inc) : l:default
endfunction

"" Put your dentures in
function! dentures#select (line, space, more, mode)
    "" Find the nearest nonblank
    let l:line = dentures#nearest(a:line, '!empty')

    if !l:line
        return ''
    endif

    "" Build the expr which determines the boundaries of the denture
    let l:expr = a:more ? 'lower' : 'empty ? equal : lower'

    "" Find boundary lines of the denture. Default to values that will produce 0 on failure, after adjustment
    let l:fline = dentures#nearest(l:line, l:expr, -1, -1) + 1
    let l:lline = dentures#nearest(l:line, l:expr, +1, +1) - 1

    "" Bail out if we couldn't find anything
    if !l:fline || !l:lline
        return ''
    endif

    "" If we are supposed to include trailing space (successive empty lines), go find it
    if a:space && (l:lline == line('$') || !empty(getline(l:lline + 1)))
        "" Handle special cases where we should grab leading space instead
        let l:fline = dentures#nearest(l:fline - 1, '!empty', -1, l:fline - 1) + 1
    elseif a:space
        "" Expand l:lline to include any empty lines that might come after it
        let l:lline = dentures#nearest(l:lline + 1, '!empty', +1, l:lline + 1) - 1
    endif

    "" Select the denture
    return ":\<C-u>normal! ".l:fline."gg^\<C-v>".a:mode.l:lline."gg$\<CR>"
endfunction
