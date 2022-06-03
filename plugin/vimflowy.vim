
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

" The last line that is a descendent of line
" E.g. the first line with indent <= line's
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

" line of level parent. a:line if level==0 Otherwise the level^th parent
" Returns 1 if it doesn't have that many parents.
" In other words the first line with indent less or equal to line - 4*level
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

nnoremap zz :<C-U>call FocusContext(v:count)<CR>
nnoremap z<CR> :<C-U>call FoldChildren(v:count1)<CR>
" TODO: rebind za,zo,zc,zr,zm to their logical behavior?
" Requires saving the fold state?
set foldtext=MyFoldText()
function! MyFoldText()
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

augroup AutoSaveGroup
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end
set viewoptions=folds,cursor
set sessionoptions=folds
