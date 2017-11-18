
" Vim IMproved aka vim configuration file ($HOME/.vimrc)
"
" Encoding : UTF-8
" System   : FreeBSD 6.2
" Author   : Nebelwerfer

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" How to let vim listchar work under not utf8 environment?
" http://superuser.com/questions/556915/how-to-let-vim-listchar-work-under-not-utf8-environment
scriptencoding utf-8

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
" set history=500		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set showmode
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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
  set autoindent			" always set autoindenting on (установить автоотступ)
endif " has("autocmd")

" set t_Co=88
if has("gui_running")
    colorscheme rootwater
    set lines=32
    set columns=106
    set guifont=DejaVu\ Sans\ Mono\ 10		" шрифт в гую
" 	set guifont=Liberation\ Mono\ 8
    set guioptions=acegit				" гуйные flags
else
    if strftime("%H") < 10
        colorscheme jellybeans
    else
        if strftime("%H") < 19
            colo murphy
        else
            colorscheme jellybeans
        endif
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

if v:version < 700
    set listchars=tab:>-,trail:+,extends:>,precedes:<,nbsp:%,eol:$	" отображение невидимых символов
else
    set listchars=tab:▸-,trail:·,extends:>,precedes:<,nbsp:%,eol:¶	" http://objectmix.com/editors/762830-vim-6-3-listchars.html
endif

" http://linsovet.org.ua/vim-cmd-line-autocompletion
" set wildmode=list:longest,list
"
" tmux compatibility (http://stackoverflow.com/questions/6427650/vim-in-tmux-background-color-changes-when-paging)
set t_ut=
" For Ansible YAML syntax plugin
" let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_unindent_after_newline = 1

" Кусок с modelines предотвращает некоторые дыры в безопасности, имеющие отношение к modelines в файлах.
" set modeline=0
" set verbose=9
set showmatch						" проверка скобок [?]
set list						" обеспечение listchars
set linebreak						" переносить строки по словам
set number						" отображение номеров строк
" set relativenumber

" encoding stuff
set encoding=utf-8					" текущая кодировка      
set termencoding=utf-8					" кодировка терминала
set fileencodings=utf-8,cp1251,cp866,koi8-r		" возможные кодировки и последовательность определения

" set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set keymap=russian-jcukenwin				" русская языка (второй способ)
set iminsert=0						" --"--
set imsearch=0						" --"--
highlight lCursor guifg=NONE guibg=Red			" меняем цвет курсора при рус. раскладке

set autoread
set directory=~/.tmp
set backupdir=~/.tmp
set clipboard=unnamed					" use default x-clipboard
set cpo+=w						" изменение поведения при замене слова

if has("vim_starting")
"	folding
	set foldenable					" Enable folds
	set foldmethod=indent
"	set foldcolumn=3
"
	set mouse=n
	set autochdir						" автосмена каталога
endif

set ignorecase						" игнорировать регистр при поиске
set smartcase						" поиск как в less
set autoindent						" автоотступы
set smartindent						" 'умныя' отступы

" Настройки табуляции
set tabstop=8
set shiftwidth=4
set softtabstop=4
set noexpandtab

set nowrap						" не переносить строки
set popt+=syntax:y					" Syntax when printing
set scrolloff=3						" Try to show at least three lines 
set sidescrolloff=2					" and two columns of context when scrolling
" set sm						" 
set noruler						" нэ нада
set statusline=\ \ %f\ %1*%m%*\ %R%=\'%F\'\ %4l(%p%%):%c\ 0x%2B\ %y,%{&encoding}\ 	" вид строки статуса
set laststatus=2					" строка статуса всегда видима
set virtualedit=block					" [ insert | all ]
set history=2048					" размер истории
set ttyfast
set shortmess=oOI

" псевдоменю
" source ~/.vim.menu
set wildmenu
set cpo-=<
set wildcharm=<C-Z>
"map <F9> :emenu <C-Z>
map <F8> :emenu F8.<C-Z>
" Menu Encoding®©«»°™…„“—“”
menu F8.Encoding\ (read)	:emenu Encoding.<C-Z>
menu F8.Fenc\ (write)		:emenu Fenc.<C-Z>
menu F8.Hex			:emenu Hex.<C-Z>

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


map <leader>e		:e ++enc=cp1251<CR>
map <leader>E		:e ++enc=utf-8<CR>

" вставляем по Shift+Insert
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" запуск файлменеджера
map <F6> <Esc>:Explore<CR>
" Типа режим чтения книжков с переносами
nmap <leader>r :set nolist<CR>:set wrap<CR>
nmap <leader>R :set list<CR>:set nowrap<CR>
map! <F11> <Esc>:bp!<CR>
" автоскобки
" imap { {<CR>}<Esc>O
" imap [ []<Left>
" imap ( ()<Left>
" imap (( ((<Space><Space>))<Left><Left><Left>
" переназначаем клавишу Y на более логичное действие (moolenaar сам это советует)
map Y y$

" следующий буфер
nmap <leader>n :bn!<CR>
" map! <leader>n <Esc>:bn!<CR>
" предыдущий буфер
nmap <leader>p :bp!<CR>
" map! <leader>p <Esc>:bp!<CR>

" Привязка <leader><space> позволяет легко очистить результаты поиска, набрав
" <leader><space>. Это позволяет избавится от отвлекающей подсветки, когда нужное уже
" нашлось.
nnoremap <leader><space> :noh<cr>
" <leader>w открывает новый вертикальный сплит и переключается на него.
nnoremap <leader>w <C-w>v<C-w>l

" проверяет первую строку сохраняемого файла и, 
" если она начинается с "#!" и содержит "/bin/", 
" присваивает последнему исполняемый атрибут.
" au BufWritePost *
" 			\ if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" |
" 			\ silent !chmod a+x % |
" 			\ endif | endif

" само пересчитывает vimrc при изменении оного
" au BufWritePost ~/.vimrc execute "normal :source %"

" ADVANCED COMMENTS " csym here is variable which contains comment symbol, like `#' or `"'
" Comment line(s)
map <leader>c :exe "s/^/".csym." /"<CR> :nohls<CR>
vmap <leader>c :call VisComment(csym)<CR>
" Uncomment line(s)
map <leader>u :exe "s/^".csym." //"<CR> :nohls<CR>
vmap <leader>u :call VisUncomment(csym)<CR>

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
au! BufNewFile,BufRead *.c let csym="/*"
au! BufNewFile,BufRead *.vim let csym="\""
au! BufNewFile,BufRead .vimrc let csym="\""
" END OF ADVANCED COMMENTS

" Примучания

" :w !sudo tee %	запись через sudo
" o	редактировать выделение
" gv	выделить заново
" :ls	просмотреть текущие буферы

:nnoremap <A-a> <C-a>
:nnoremap <A-x> <C-x>
