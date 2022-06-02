" Let's steal zz for focus on current bullet and z[enter] for focus on current
" context. We can take [number] operator to unfurl that amount of upper or
" lower context.

nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

function! HeadOf(line, next, level)
    if (a:next==0 && (a:level==0 || indent(a:line)==0))
        if (a:level>0)
            return 1
        endif
        return a:line
    endif
    let l:indent = indent(a:line)
    let l:at = a:line
    if (a:level==0)
        let l:at = l:at + 1
    endif
    let l:last = line('$')
    while (indent(l:at)+4*a:level>l:indent && l:at>1)
        if (l:at == l:last)
            return l:at + 1
        endif
        let l:at = l:at-1+2*a:next
    endwhile
    return l:at
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
    let l:line = line('.')
    if (a:start>1)
        exec "1,".(a:start-1)."fold"
    endif
    if (a:end<line('$'))
        exec "".(a:end+1).",$"."fold"
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
    normal zR
    let l:start = line('.')
    let l:head = HeadOf(l:start, 0, a:level)
    let l:tail = HeadOf(l:start, 1, a:level)
    let l:tail = l:tail - 1
    if (l:tail<l:head)
        let l:tail = l:head
    endif
    call WrapOutside(l:head, l:tail)
    call HideIndent(indent(l:head))
endfunction

function! Head()
    let l:line = line('.')
    return HeadOf(l:line, 0, 1)
endfunction

function! Tail()
    let l:line = line('.')
    return HeadOf(l:line, 1, 1)
endfunction

function! FoldChildren(open, all)
    let l:start = line('.')
    let l:end = HeadOf(l:start, 1, 0)-1
    echom l:end
    if (a:open)
        if (a:all)
            let l:cmd = "".l:start.",".l:end."foldopen"
        else
            let l:cmd = "".l:start.",".l:end."foldopen!"
        endif
    else
        if (a:all)
            let l:cmd = "".l:start.",".l:end."foldclose"
        else
            let l:cmd = "".l:start.",".l:end."foldclose!"
        endif
    endif
    exec l:cmd
endfunction

" Leave folds outside of this bullets children untouched
"
function! FoldChildren(level)
    let l:start = line('.')
    let l:sind = indent(l:start)
    let l:end = HeadOf(l:start, 1, 0)-1
    let l:last = -1
    let l:at = l:start
    exec l:start.",".l:end."fold"
    exec "".l:start.",".l:end."foldopen!"
    while (l:at <= l:end)
        if (l:last == -1 && indent(l:at)-l:sind>=4*a:level)
            let l:last = l:at
        endif
        if (l:last != -1 && (indent(l:at)-l:sind<4*a:level || l:at == l:end))
            if (indent(l:at)-l:sind<4*a:level)
                exec l:last.",".(l:at-1)."fold"
            else
                exec l:last.",".(l:at)."fold"
            endif
            let l:last = -1
        endif
        let l:at = l:at + 1
    endwhile
endfunction

nnoremap zz :<C-U>call FocusContext(v:count)<CR>
nnoremap z<CR> :<C-U>call FoldChildren(v:count1)<CR>
" nnoremap zm :<C-U>call FoldChildren(0, 0)<CR>
" nnoremap zr :<C-U>call FoldChildren(1, 0)<CR>
" nnoremap zM :<C-U>call FoldChildren(0, 1)<CR>
" nnoremap zR :<C-U>call FoldChildren(1, 1)<CR>
