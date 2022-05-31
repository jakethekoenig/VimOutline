
" if exists("g:loaded_vimflowy")
	" finish
" endif
let g:loaded_vimflowy = 1

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
