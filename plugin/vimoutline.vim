
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

function! EndContext(line)
    if (a:line == 1)
        return line('$')
    endif
    let l:indent = indent(a:line)
    let l:at = a:line + 1
    while (indent(l:at) > l:indent)
        if (l:at == line('$'))
            return l:at
        endif
        let l:at = l:at + 1
    endwhile
    return l:at - 1
endfunction

function! Parent(line, level)
    if (a:level == 0)
        return a:line
    endif
    let l:at = a:line
    while (indent(l:at) > indent(a:line) - 4*a:level && l:at>1)
        let l:at = l:at - 1
    endwhile
    return l:at
endfunction

" Returns the line of the step^th sibling. 0 returns line. Negative numbers
" return previous siblings. If line doesn't have that many siblings it returns
" the first or last sibling

function! Sibling(line, step)
    if (a:step == 0)
        return a:line
    endif
    if (a:step>0)
        let l:next = EndContext(a:line) + 1
        if (indent(l:next)<indent(a:line))
            return a:line
        endif
        return Sibling(l:next, a:step - 1)
    else
        let l:previous = a:line - 1
        if (indent(l:previous) < indent(a:line))
            return a:line
        else
            let l:diff = (indent(l:previous) - indent(a:line))/4
            return Sibling(Parent(l:previous, l:diff), a:step+1)
        endif
    endif
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
    let l:line = line('.')
    if (a:start>1)
        exec "1,".(a:start-1)."fold"
    endif
    if (a:end<line('$'))
        exec "".(a:end+1).",$fold"
    endif
endfunction

function! HideIndent(level)
    doautocmd Syntax
    " TODO: put these file level?
    set conceallevel=2
    set concealcursor=nvic
    if (a:level>0)
        let l:s = 'syn match Concealed "^.\{' . a:level . '\}" conceal'
        exec l:s
    endif
endfunction

function! FocusContext(level)
    normal zE
    let l:start = line('.')
    let l:head = Parent(l:start, a:level)
    let l:tail = EndContext(l:head)
    call WrapOutside(l:head, l:tail)
    call HideIndent(indent(l:head))
endfunction

function! FoldChildren(level)
    let l:start = line('.')
    let l:sind = indent(l:start)
    let l:end = EndContext(l:start)
    let l:last = -1
    let l:at = l:start
    exec l:start.",".l:end."fold"
    exec "".l:start.",".l:end."foldopen!"
    while (l:at <= l:end)
        if (l:last == -1 && indent(l:at)-l:sind>4*a:level)
            let l:last = l:at
        endif
        if (l:last != -1 && (indent(l:at)-l:sind<=4*a:level || l:at == l:end))
            if (indent(l:at)-l:sind<=4*a:level)
                exec l:last.",".(l:at-1)."fold"
            else
                exec l:last.",".(l:at)."fold"
            endif
            let l:last = -1
        endif
        let l:at = l:at + 1
    endwhile
endfunction
