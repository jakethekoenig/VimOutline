if exists('g:vimoutline_mappings')
  finish
endif
let g:vimoutline_mappings = 1

" Mappings
nnoremap <buffer> zz :<C-U>call VimOutline#FocusContext(v:count)<CR>
nnoremap <buffer> z<CR> :<C-U>call VimOutline#FoldChildren(v:count)<CR>
" No command to fold children?
" TODO: rebind za,zo,zc,zr,zm to their logical behavior?

nnoremap <buffer> { :<C-U>call VimOutline#GoToSibling('.',-v:count1)<CR>
nnoremap <buffer> } :<C-U>call VimOutline#GoToSibling('.',v:count1)<CR>
nnoremap <buffer> gp :<C-U>call VimOutline#GoToParentAndOpen('.', v:count1)<CR>
