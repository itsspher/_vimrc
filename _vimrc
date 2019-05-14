source $VIMRUNTIME/vimrc_example.vim

set nobackup
set nowritebackup

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

function! LF()
	let temp = tempname()
	exec 'silent !lf -selection-path='.shellescape(temp)
	if !filereadable(temp)
		redraw!
		return
	endif
	let names = readfile(temp)
	if empty(names)
		redraw!
		return
	endif
	exec 'edit ' . fnameescape(name)
	for name in names[1:]
		exec 'argadd ' . fnameescape(name)
	endfor
	redraw!
endfunction
command! -bar LF call LF()

" vim plugins
call plug#begin('~/.vim/plugged')

Plug 'plasticboy/vim-markdown'
Plug 'reedes/vim-pencil'

call plug#end()

" Luke Smith's guide navigation
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
vnoremap <Space><Space> <Esc>/<++><Enter>"_c4l
map <Space><Space> <Esc>/<++><Enter>"_c4l

" Markdown macros
autocmd Filetype markdown,rmd inoremap ,m $$<Enter><Enter>$$<Enter><Enter><++><Esc>kkkA
autocmd Filetype markdown,rmd inoremap ,n ---<Enter><Enter>
autocmd Filetype markdown,rmd inoremap ,b ****<++><Esc>F*hi
autocmd Filetype markdown,rmd inoremap ,s ~~~~<++><Esc>F~hi
autocmd Filetype markdown,rmd inoremap ,e **<++><Esc>F*i
autocmd Filetype markdown,rmd inoremap ,g {}{<++>} <++><Esc>11hci{
