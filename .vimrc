
" Vim configuration file ($HOME/.vimrc)
"
" Encoding : UTF-8
" System   : FreeBSD 6.2
" Author   : nbw

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" How to let vim listchar work under not utf8 environment?
" http://superuser.com/questions/556915/how-to-let-vim-listchar-work-under-not-utf8-environment
scriptencoding utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set showcmd		" display incomplete commands
set showmode
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END
else
  set autoindent			" always set autoindenting on
endif " has("autocmd")

if has("vim_starting")
"	set foldenable
"	set foldmethod=indent

	set mouse=n
	set autochdir
endif

if has("gui_running")
    " nice schemes for GUI: 
    "				Dark: darkblue, desert, inkpot, jellybeans, moria 
    "				Bright: default, peachpuff, zellner
    colorscheme desert
    set lines=36
    set columns=156
    set guifont=DejaVu\ Sans\ Mono\ 10
    set guioptions=acegit
else
"     if strftime("%H") < 10
"         colorscheme jellybeans
"     else
"         if strftime("%H") < 19
"             colo murphy
"         else
"             colorscheme jellybeans
"         endif
"     endif
    if v:version > 700
	set background=dark
	colorscheme gruvbox
    else
	colorscheme murphy
    endif
endif

" http://vim.wikia.com/wiki/Ignore_white_space_in_vimdiff
if &diff
    " diff mode
    set diffopt+=iwhite
    " http://stackoverflow.com/questions/1265410/is-there-a-way-to-configure-vimdiff-to-ignore-all-whitespaces
    set diffexpr=DiffW()
    function DiffW()
    let opt = ""
     if &diffopt =~ "icase"
       let opt = opt . "-i "
     endif
     if &diffopt =~ "iwhite"
       let opt = opt . "-w " " vim uses -b by default
     endif
     silent execute "!diff -a --binary " . opt .
       \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
    endfunction

    colorscheme inkpot
endif
" http://objectmix.com/editors/762830-vim-6-3-listchars.html
if v:version < 700
    set listchars=tab:>-,trail:+,extends:>,precedes:<,nbsp:%,eol:$
else
    set listchars=tab:▸-,trail:·,extends:>,precedes:<,nbsp:%,eol:¶
endif

" tmux compatibility (http://stackoverflow.com/questions/6427650/vim-in-tmux-background-color-changes-when-paging)
set t_ut=
" For Ansible YAML syntax plugin
" let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_unindent_after_newline = 1

set list						" обеспечение listchars
set linebreak						" переносить строки по словам
set number						" отображение номеров строк

set encoding=utf-8					" текущая кодировка
set termencoding=utf-8					" кодировка терминала
set fileencodings=utf-8,cp1251,cp866,koi8-r		" возможные кодировки и последовательность определения

set keymap=russian-jcukenwin				" русская языка (второй способ)
set iminsert=0						" --"--
set imsearch=0						" --"--

" set autoread
set directory=~/.tmp
set backup		" keep a backup file
set backupdir=~/.tmp

set smartcase
set autoindent
set smartindent

set tabstop=8
set shiftwidth=4
set softtabstop=4
set noexpandtab

set nowrap
set scrolloff=3						" Try to show at least three lines 
set sidescrolloff=2					" and two columns of context when scrolling
set statusline=\ \ %f\ %1*%m%*\ %R%=\'%F\'\ %4l(%p%%):%c\ 0x%2B\ %y,%{&encoding}\
set laststatus=2					" строка статуса всегда видима
set virtualedit=block					" [ insert | all ]
set history=2048
set ttyfast

set wildmenu
set wildmode=list:longest,full
set wildcharm=<C-Z>
map <F9> :emenu F9.<C-Z>
menu F9.Encoding\ (read)	:emenu Encoding.<C-Z>
menu F9.Fenc\ (write)		:emenu Fenc.<C-Z>
menu F9.Hex			:emenu Hex.<C-Z>

menu Encoding.cp1251	:e ++enc=cp1251<CR>
menu Encoding.cp866	:e ++enc=cp866<CR>
menu Encoding.koi8-r	:e ++enc=koi8-r<CR>
menu Encoding.utf-8	:e ++enc=utf-8<CR>
menu Encoding.unicode	:e ++enc=unicode<CR>
menu Encoding.EOL:unix	:e ++ff=unix<CR>
menu Encoding.EOL:dos	:e ++ff=dos<CR>
menu Encoding.EOL:mac	:e ++ff=mac<CR>

menu Fenc.cp1251	:set fenc=cp1251<CR>
menu Fenc.cp866		:set fenc=cp866<CR>
menu Fenc.koi8-r	:set fenc=koi8-r<CR>
menu Fenc.utf-8		:set fenc=utf-8<CR>
menu Fenc.unicode	:set fenc=unicode<CR>
menu Fenc.EOL:unix	:set ff=unix<CR>
menu Fenc.EOL:dos	:set ff=dos<CR>
menu Fenc.EOL:mac	:set ff=mac<CR>

menu Hex.HEX		:%!xxd<CR>
menu Hex.ASCII		:%!xxd -r<CR>

nmap <leader>e		:e ++enc=cp1251<CR>
nmap <leader>E		:e ++enc=utf-8<CR>

" Paste mode
nnoremap <leader>p	:set invpaste paste?<CR>

" Read mode
nmap <leader>r		:set nolist<CR>:set wrap<CR>:set nonumber<CR>
nmap <leader>R		:set list<CR>:set nowrap<CR>:set number<CR>
" переназначаем клавишу Y на более логичное действие (moolenaar сам это советует)
map Y y$

" Next/prev buffer
nmap <leader>l		:bn<CR>
nmap <leader>h		:bp<CR>
" Clear search highlight
nnoremap <leader><space>	:nohls<cr>

" ADVANCED COMMENTS BEGIN
" csym here is variable which contains comment symbol, like `#' or `"'
" Comment line(s)
map <leader>c		:exe "s/^/".csym." /"<CR> :nohls<CR>
vmap <leader>c		:call VisComment(csym)<CR>
" Uncomment line(s)
map <leader>u		:exe "s/^".csym." //"<CR> :nohls<CR>
vmap <leader>u		:call VisUncomment(csym)<CR>

fun! VisComment(c)
  exe "s/^/".a:c." /"
endfunction

fun! VisUncomment(c)
  exe "s/^".a:c." //"
endfunction

" Set `csym' according to file type
au! BufNewFile,BufRead * let csym="#"
au! BufNewFile,BufRead *.pp let csym="//"
au! BufNewFile,BufRead *.cpp let csym="//"
au! BufNewFile,BufRead *.php let csym="//"
au! BufNewFile,BufRead *.c let csym="/*"
au! BufNewFile,BufRead *.vim let csym="\""
au! BufNewFile,BufRead .vimrc let csym="\""
" ADVANCED COMMENTS END

" Notes

" :w !sudo tee %	запись через sudo
" o	редактировать выделение
" gv	выделить заново
" :ls	просмотреть текущие буферы

if v:version > 700
    execute pathogen#infect()
endif
" EOF
