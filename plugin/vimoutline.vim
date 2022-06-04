
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

" Returns the line number of the last bullet that is a descendant of line.
function! EndOfContext(line)
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

" TODO: make recursive
" Returns the line number of (level-1)^th great parent of line. In other words
" if level==0 it returns line, if level==1 it returns line's parent and so on.
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

" Moves to the parent as described by the parent function.
function! GoToParent(line, level)
    " TODO: guard everything in this way?
    if (a:line=='.')
        let l:line = line('.')
    else
        let l:line = a:line
    endif
    let l:ans = Parent(l:line, a:level)
    echom l:ans
    exe l:ans
endfunction

" Returns the line of the step^th sibling. 0 returns line. Negative numbers
" return previous siblings. If line doesn't have that many siblings it returns
" the first or last sibling
" Uses current line if line=='.' otherwise expects number
function! Sibling(line, step)
    if (a:line=='.')
        let l:line = line('.')
    else
        let l:line = a:line
    endif
    if (a:step == 0)
        return l:line
    endif
    if (a:step>0)
        let l:next = EndOfContext(l:line) + 1
        if (indent(l:next)<indent(l:line))
            return l:line
        endif
        return Sibling(l:next, a:step - 1)
    else
        let l:previous = l:line - 1
        if (indent(l:previous) < indent(l:line))
            return l:line
        else
            let l:diff = (indent(l:previous) - indent(l:line))/4
            return Sibling(Parent(l:previous, l:diff), a:step+1)
        endif
    endif
endfunction

function! GoToSibling(line, step)
    let l:sib = Sibling(a:line, a:step)
    exe l:sib
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
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
    let l:start = line('.')
    let l:head = Parent(l:start, a:level)
    let l:tail = EndOfContext(l:head)
    silent! normal ggzDGzD
    call WrapOutside(l:head, l:tail)
    call HideIndent(indent(l:head))
    exec l:start
endfunction

function! FoldChildren(level)
    let l:start = line('.')
    let l:sind = indent(l:start)
    let l:end = EndOfContext(l:start)
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
