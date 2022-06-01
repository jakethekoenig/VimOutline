
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

function! JumpIndent(forward, relativeindent)
    let line = line('.')
    let column = col('.')
    let at = line
    let last = line('$')
    while (at <= last)
        let at = at + 2 * forward - 1
        " TODO: use variable for 4
        if (indent(at) + 4*relativeindent <= indent(line))
            return at
        endif
    endwhile
    return line
endfunction

function! BulletContext()
    let line = line('.')
    let start = JumpIndent(0, 1)
    exe start
    call FocusBullet()
    exe line
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
    let line = line('.')
    if (a:start>1)
        exe "normal ggzf" . (a:start-2) . "j"
    endif
    exe  "" . (a:end+1)
    normal zfG
    exe "" . line
endfunction

function! FocusBullet()
    normal zR
    let start = line('.')
    let end = JumpIndent(1, 0)-1
    if (end<start)
        let end = start
    endif
    call WrapOutside(start, end)
    doautocmd Syntax
    set conceallevel=2
    set concealcursor=nvic
    if (indent(start)>0)
        let s = 'syn match Concealed "^.\{' . indent(start) . '\}" conceal'
        exec s
    endif
endfunction

function! ResetBullet()
    normal zR
    syntax match Concealed '' conceal
    syntax clear Concealed
    doautocmd Syntax
endfunction

nnoremap <localleader><CR> :call FocusBullet()<CR>
nnoremap <localleader><BS> :call ResetBullet()<CR>
