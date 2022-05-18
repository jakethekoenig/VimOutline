
echo "test"

if exists("g:loaded_vimflowy")
	finish
endif
let g:loaded_vimflowy = 1

echo "test"

nnoremap <leader>n :tabe ~/.vimflowy.note<cr>
