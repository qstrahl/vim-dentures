"" Find a line around a given line based on evaluated expressions
"  "line"       - the line to start looking from
"  "inc"        - the amount to increment by each time (if 0, will increment by 1 then reverse if no match found)
"  "match"      - an expression that evals true if the current line is a valid candidate
"  "stop"       - an expression that evals true when we should stop looking
function! dentures#find (line, inc, match, stop)
    "" If inc is 0, we should look forward 1 line at a time then look backward if nothing is found at first
    let l:reverse = !a:inc
    let l:inc = a:inc ? a:inc : +1

    "" Current line being examined
    let l:line = a:line

    "" Current line being examined
    let l:line = a:line

    "" Indent level of the first line we're given
    let l:firstIndent = indent(a:line)

    "" Current indent level (we'll set it for real later, but we need to do this here to set "prevIndent" in the loop)
    let l:indent = l:firstIndent

    "" Is the current line empty? (Need to define this here for "prevEmpty" to be set in the loop)
    let l:empty = 0

    "" Last line to be matched by a:match
    let l:matched = 0

    "" Stop when we hit the beginning or end of file
    while l:line >= 1 && l:line <= line('$')
        "" Compute helpful values for use in "match" and "stop" expressions
        let l:prevEmpty = l:empty
        let l:prevIndent = l:indent
        let l:prevEqual = l:prevIndent == l:firstIndent
        let l:empty = empty(getline(l:line))
        let l:indent = l:empty ? l:indent : indent(l:line)
        let l:lower = l:indent < l:firstIndent
        let l:lowerOrEqual = l:indent <= l:firstIndent

        "" Check if we should stop
        if eval(a:stop)
            break
        endif

        "" Check if this line is a match
        if eval(a:match)
            let l:matched = l:line
        endif

        "" Finally increment the line number
        let l:line += l:inc
    endwhile

    "" If we found a match, return it. Or if we should look in the other direction, do that. Or return 0
    return l:matched ? l:matched : l:reverse ? dentures#find(a:line, -l:inc, a:match, a:stop) : 0
endfunction

"" Put your dentures in
function! dentures#select (line, space, more, mode)
    "" Find the first nonblank near the cursor
    let l:line = dentures#find(a:line, 0, '!empty', 'l:matched')

    if !l:line
        return ''
    endif

    "" Build the exprs which determines the boundaries of the denture. Abandon all hope, ye who enter here
    let l:match = '!empty'
    let l:stop = a:more ? 'lower' : '(!empty && prevEmpty && prevEqual) ? lowerOrEqual : lower'

    "" Find boundary lines of the denture. Default to values that will produce 0 on failure, after adjustment
    let l:fline = dentures#find(l:line, -1, l:match, l:stop)
    let l:lline = dentures#find(l:line, +1, l:match, l:stop)

    "" If we are supposed to include trailing space (successive empty lines), go find it
    if a:space && (l:lline == line('$') || !empty(getline(l:lline + 1)))
        "" Handle special cases where we should grab leading space instead
        let l:newfline = dentures#find(l:fline - 1, -1, 'empty', '!empty')
        let l:fline = l:newfline ? l:newfline : l:fline
    elseif a:space && empty(getline(l:lline + 1))
        "" Expand l:lline to include any empty lines that might come after it
        let l:newlline = dentures#find(l:lline + 1, +1, 'empty', '!empty')
        let l:lline = l:newlline ? l:newlline : l:lline
    endif

    "" Select the denture
    return ":\<C-u>normal! ".l:fline."gg^\<C-v>".a:mode.l:lline."gg$\<CR>"
endfunction
