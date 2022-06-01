
nnoremap <leader>n :tabe ~/.vimflowy.note<cr>

function! JumpIndent()
    let line = line('.')
    let column = col('.')
    let at = line
    let last = line('$')
    while (at <= last)
        let at = at + 1
        if (indent(at) < indent(line))
            return line
        endif
        if (indent(at) == indent(line))
            return at
        endif
    endwhile
    return line
endfunction

function! WrapOutside(start, end)
    set foldmethod=manual
    let line = line('.')
    if (a:start>1)
        exe "normal ggzf" . (a:start-2) . "j"
    endif
    exe  "" . (a:end+1)
    exe "normal zfG"
    exe "" . line
endfunction

function! FocusBullet()
    let start = line('.')
    let end = JumpIndent()-1
    call WrapOutside(start, end)
    syntax match Concealed '' conceal
    syntax clear Concealed
    set conceallevel=2
    set concealcursor=nvic
    let s = 'syn match Concealed "^.\{' . indent(start) . '\}" conceal'
    exec s

endfunction
