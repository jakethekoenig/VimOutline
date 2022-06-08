if exists('g:vimoutline_settings')
  finish
endif
let g:vimoutline_settings = 1

" Outline Style
set viewoptions=folds,cursor
set sessionoptions=folds
set foldtext=vimoutline#BulletFoldText()
set nocursorline
set nocursorcolumn


augroup AutoSaveGroup
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end
