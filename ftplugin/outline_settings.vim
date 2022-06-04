" Outline Style
set viewoptions=folds,cursor
set sessionoptions=folds
set foldtext=BulletFoldText()
set nocursorline
set nocursorcolumn


function! BulletFoldText()
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
