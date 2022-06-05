
" Mappings
nnoremap <buffer> zz :<C-U>call FocusContext(v:count)<CR>
nnoremap <buffer> z<CR> :<C-U>call FoldChildren(v:count)<CR>
" No command to fold children?
" TODO: rebind za,zo,zc,zr,zm to their logical behavior?

nnoremap <buffer> { :<C-U>call GoToSibling('.',-v:count1)<CR>
nnoremap <buffer> } :<C-U>call GoToSibling('.',v:count1)<CR>
nnoremap <buffer> gp :<C-U>call GoToParentAndOpen('.', v:count1)<CR>
