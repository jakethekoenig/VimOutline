
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

function! JumpIndent(forward, relativeindent)
    let l:line = line('.')
    let l:column = col('.')
    let l:at = line
    let l:last = line('$')
    while (l:at <= l:last && l:at>=1)
        let l:at = l:at + 2 * a:forward - 1
        " TODO: use variable for 4
        if (indent(l:at) + 4*a:relativeindent <= indent(l:line))
            return l:at
        endif
    endwhile
    return l:line
endfunction

function! BulletContext()
    let l:line = line('.')
    let l:start = JumpIndent(0, 1)
    exe l:start
    call FocusBullet()
    exe l:line
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
    let l:line = line('.')
    if (a:start>1)
        exe "normal ggzf" . (a:start-2) . "j"
    endif
    exe  "" . (a:end+1)
    normal zfG
    exe "" . l:line
endfunction

function! FocusBullet()
    normal zR
    let l:start = line('.')
    let l:end = JumpIndent(1, 0)-1
    if (l:end<l:start)
        let l:end = l:start
    endif
    call WrapOutside(l:start, l:end)
    doautocmd Syntax
    set conceallevel=2
    set concealcursor=nvic
    if (indent(l:start)>0)
        let l:s = 'syn match Concealed "^.\{' . indent(l:start) . '\}" conceal'
        exec l:s
    endif
endfunction

function! ResetBullet()
    normal zR
    syntax match Concealed '' conceal
    syntax clear Concealed
    doautocmd Syntax
endfunction

function! Head()
    let l:line = line('.')
    return HeadOf(l:line, 0)
endfunction

function! Tail()
    let l:line = line('.')
    return HeadOf(l:line, 1)
endfunction

function! HeadOf(line, next)
    let l:indent = indent(a:line)
    let l:at = a:line
    while (indent(l:at)>=l:indent && l:at>1)
        let l:at = l:at-1+2*a:next
    endwhile
    return l:at
endfunction

nnoremap <localleader><CR> :call FocusBullet()<CR>
nnoremap <localleader><BS> :call ResetBullet()<CR>
