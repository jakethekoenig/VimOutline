" The functions in this file are intended for internal use but some of them,
" such as EndOfContext and Parent may be independently useful for example when
" editing python files.

if exists('g:vimoutline')
  finish
endif
let g:vimoutline = 1

" Returns the line number of the last bullet that is a descendant of line.
function! vimoutline#EndOfContext(line)
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
function! vimoutline#Parent(line, level)
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
function! vimoutline#GoToParent(line, level)
    " TODO: guard everything in this way?
    if (a:line=='.')
        let l:line = line('.')
    else
        let l:line = a:line
    endif
    let l:ans = vimoutline#Parent(l:line, a:level)
    echom l:ans
    exe l:ans
endfunction

function! vimoutline#GoToParentAndOpen(line, level)
    call vimoutline#GoToParent(a:line, a:level)
    if (foldclosed(line('.')) != -1)
        call vimoutline#FocusContext(0)
    endif
endfunction

" Returns the line of the step^th sibling. 0 returns line. Negative numbers
" return previous siblings. If line doesn't have that many siblings it returns
" the first or last sibling
" Uses current line if line=='.' otherwise expects number
function! vimoutline#Sibling(line, step)
    if (a:line=='.')
        let l:line = line('.')
    else
        let l:line = a:line
    endif
    if (a:step == 0)
        return l:line
    endif
    if (a:step>0)
        let l:next = vimoutline#EndOfContext(l:line) + 1
        if (indent(l:next)<indent(l:line))
            return l:line
        endif
        return vimoutline#Sibling(l:next, a:step - 1)
    else
        let l:previous = l:line - 1
        if (indent(l:previous) < indent(l:line))
            return l:line
        else
            let l:diff = (indent(l:previous) - indent(l:line))/4
            return vimoutline#Sibling(vimoutline#Parent(l:previous, l:diff), a:step+1)
        endif
    endif
endfunction

" Moves current line to sibling as defined by Sibling
function! vimoutline#GoToSibling(line, step)
    let l:sib = vimoutline#Sibling(a:line, a:step)
    exe l:sib
endfunction

" Makes two new folds. One from the beginning to start and one from end to the
" end of file.
function! vimoutline#WrapOutside(start, end)
    set foldmethod=manual
    if (a:start>1)
        exec "1,".(a:start-1)."fold"
    endif
    if (a:end<line('$'))
        exec "".(a:end+1).",$fold"
    endif
endfunction

" Hides the first 4*level characters of each line
function! vimoutline#HideIndent(level)
    doautocmd Syntax
    " TODO: put these file level?
    set conceallevel=2
    set concealcursor=nvic
    if (a:level>0)
        let l:s = 'syn match Concealed "^.\{' . a:level . '\}" conceal'
        exec l:s
    endif
endfunction

" Finds the level^th parent of the current line and the end of it's context
" than WrapOutsides those lines and hides the indent.
function! vimoutline#FocusContext(level)
    let l:start = line('.')
    let l:head = vimoutline#Parent(l:start, a:level)
    let l:tail = vimoutline#EndOfContext(l:head)
    silent! normal ggzDGzD
    call vimoutline#WrapOutside(l:head, l:tail)
    call vimoutline#HideIndent(indent(l:head))
    exec l:start
endfunction

" Folds Children below level
function! vimoutline#FoldChildren(level)
    let l:start = line('.')
    let l:sind = indent(l:start)
    let l:end = vimoutline#EndOfContext(l:start)
    let l:last = -1
    let l:at = l:start
    exec "silent! ".l:start.",".l:end."foldopen!"
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

" Styling for the fold text. TODO: make prettier.
function! vimoutline#BulletFoldText()
    let line = v:foldstart
    let end = v:foldend
    if (l:line == 1 || l:end == line('$'))
        return ""
    endif
    let l:indent = indent(line)
    let l:ans = ""
    while (strlen(l:ans)<l:indent) " There's got to be a better way to do this
        let l:ans = l:ans." "
    endwhile
    let l:ans = l:ans.(l:end-l:line + 1)." Children Hidden"
    return l:ans
endfunction
