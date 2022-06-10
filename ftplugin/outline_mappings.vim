if exists('g:vimoutline_mappings')
  finish
endif
let g:vimoutline_mappings = 1

" Mappings
nnoremap <buffer> zz :<C-U>call vimoutline#FocusContext(v:count)<CR>
nnoremap <buffer> z<CR> :<C-U>call vimoutline#FoldChildren(v:count)<CR>
" No command to fold children?
" TODO: rebind za,zo,zc,zr,zm to their logical behavior?

nnoremap <buffer> { :<C-U>call vimoutline#GoToSiblingAndOpen('.',-v:count1)<CR>
nnoremap <buffer> } :<C-U>call vimoutline#GoToSiblingAndOpen('.',v:count1)<CR>
nnoremap <buffer> gp :<C-U>call vimoutline#GoToParentAndOpen('.', v:count1)<CR>
