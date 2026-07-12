
" Vim configuration file ($HOME/.vimrc)
"
" Encoding : UTF-8
" System   : FreeBSD 6.2
" Author   : nbw

" :w !sudo tee %	запись через sudo

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if v:version > 700
    execute pathogen#infect()
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete

  if filereadable(expand("~/.vim/bundle/supertab/README.rst"))
    autocmd FileType *
      \ if &omnifunc != '' |
      \   call SuperTabChain(&omnifunc, "<c-p>") |
      \ endif

    let g:SuperTabMappingForward = '<s-tab>'
    let g:SuperTabMappingBackward = '<tab>'
  endif


  if filereadable(expand("~/.vim/bundle/commentary/plugin/commentary.vim"))
    autocmd FileType jinja2 setlocal commentstring=#\ %s
    autocmd FileType tf setlocal commentstring=#\ %s
  endif

  " https://vi.stackexchange.com/questions/10962/how-to-change-color-of-tabs-in-the-tab-bar-in-gvim
  " augroup customTabs
  "   autocmd FileType * hi TabLine guifg=#ffffcc guibg=#006699 gui=underline
  "   autocmd FileType * hi TabLineSel guifg=#ffffff guibg=#996666 gui=bold
  "   autocmd FileType * hi TabLineFill guifg=#2dbd1e guibg=#003366
  " augroup END

  " ansible-doc -t module --list | awk '{ print $1 }' > ~/.vim/words/yaml.ansible.txt
  " ansible-doc -t lookup --list | awk '{ print $1 }' >> ~/.vim/words/yaml.ansible.txt
  " ansible-doc -t filter --list | awk '{ print $1 }' >> ~/.vim/words/yaml.ansible.txt
  au FileType * execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'

  augroup ansibleDoc
    autocmd FileType yaml.ansible nmap K :AnsibleDocModule<CR>
  augroup END
else
  set autoindent			" always set autoindenting on
endif

if has("vim_starting")
"     set foldenable
"     set foldmethod=indent

    set mouse=c
    set autochdir
endif

" http://vim.wikia.com/wiki/Ignore_white_space_in_vimdiff
if &diff
    " diff mode
    set diffopt+=iwhite
    colorscheme inkpot
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
" let g:ansible_unindent_after_newline = 0
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'd'
let g:ansible_attribute_highlight = "od"
" showmarks plugin
" let g:showmarks_textlower = "'\t"
" let g:showmarks_textupper = "\t "
" let g:showmarks_textother = "\t~"

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set showcmd		" display incomplete commands
set showmode
set incsearch		" do incremental searching

set list						" обеспечение listchars
set linebreak						" переносить строки по словам
set number						" отображение номеров строк

if v:version > 800
    set nrformats=alpha,hex,bin,unsigned
endif

set iskeyword+=-
set complete+=k

" https://superuser.com/questions/783149/how-can-i-construct-a-vim-mapping-to-perform-ctrl-n-but-as-if-iskeyword-include
function! CustomComplete(type)
    set iskeyword+=.
    return a:type
endfunction
inoremap <expr> <C-B> CustomComplete("<C-P>")
autocmd CompleteDone * set iskeyword-=.

" Disable some commands; https://vi.stackexchange.com/questions/25152/how-can-i-discourage-myself-from-using-q-wq-etc-to-quit-vim
cnoremap <expr> <CR> getcmdtype() == ":" && index(["qa", "qa!"], getcmdline()) >= 0 ? "<C-u>" : "<CR>"

set encoding=utf-8					" текущая кодировка
set termencoding=utf-8					" кодировка терминала
set fileencodings=utf-8,cp1251,cp866,koi8-r		" возможные кодировки и последовательность определения

set keymap=russian-jcukenwin				" русская языка (второй способ)
set iminsert=0						" --"--
set imsearch=0						" --"--

set directory=~/.vim/tmp
set backup		" keep a backup file
set backupdir=~/.vim/tmp

set smartcase
set autoindent
set smartindent

set tabstop=8
set shiftwidth=4
set softtabstop=4
set noexpandtab

set confirm
set nowrap
set scrolloff=999					" Place cursor to the center of a window
set sidescrolloff=2					" and two columns of context when scrolling

if filereadable(expand("~/.vim/bundle/vim-fugitive/README.markdown"))
  set statusline=\ %{FugitiveStatusline()}\ %t\ %1*%m%*\ %R%=%<\'%F\'\ %4l(%p%%):%c\ 0x%2B\ %y\ %{winnr()}\ 
else
  set statusline=\ \ %t\ %1*%m%*\ %R%=%<\'%F\'\ %4l(%p%%):%c\ 0x%2B\ %y,%{&encoding}\ 
endif

" AG integration
if filereadable("/usr/bin/ag")
  set grepprg=ag\ --case-sensitive\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

set laststatus=2					" строка статуса всегда видима
set virtualedit=block					" [ insert | all ]
set history=10000
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

" nmap <leader>e		:e ++enc=cp1251<CR>
" nmap <leader>E		:e ++enc=utf-8<CR>
nmap <leader>t		:tabnew<CR>
nmap <leader>0		:tabmove 0<CR>
nmap <leader>$		:tabmove<CR>

" Paste mode
nnoremap <leader>p	:set invpaste paste?<CR>

" ToggleBool
noremap <leader>b	:ToggleBool<CR>

" переназначаем клавишу Y на более логичное действие (moolenaar сам это советует)
map Y y$

" Don't use Ex mode, use Q for formatting
map Q gq

" Clear search highlight
nnoremap <leader><space>	:nohls<CR>

" Copy full file path in unnamed buffer
map <leader>[		:let @" = expand("%:p")<CR>
map <leader>]		:let @* = expand("%:p")<CR>

" Call Neomake when writing a buffer (delay 750 ms).
if filereadable(expand("~/.vim/bundle/neomake/README.md"))
  call neomake#configure#automake('rw', 1250, 750)
endif

nmap <leader>f		:lfirst<CR>
nmap <leader>l		:llast<CR>
" marks https://vi.stackexchange.com/questions/8451/is-it-possible-to-have-vim-displaying-the-list-of-available-marks-when-using-mar
nnoremap <leader>m	:<C-u>marks<CR>:normal!<Space>'
nnoremap <leader>a	:ls<CR>:b<Space>
nnoremap <leader>z	:undolist<CR>:u<Space>

nmap <F11> :tabprevious<CR>
nmap <F12> :tabnext<CR>

" vim-fugitive "addon"
if filereadable(expand("~/.vim/bundle/vim-fugitive/README.markdown"))
  command Gxlog term git log --graph --oneline --all --decorate=full --date-order --color=always
  command -nargs=1 Gwdiff term git diff --word-diff=color <args>
  command Greview term git diff --staged
endif

if filereadable(expand("~/venv/ansible/bin/activate"))
  function! AnsibleDoc(type)
    setlocal iskeyword+=.
    let l:c_word = expand("<cword>")
    echo a:type . "/" . l:c_word
    vnew
    execute '0read !. ${HOME}/venv/ansible/bin/activate && ANSIBLE_NOCOLOR=True ansible-doc -t ' . a:type . ' ' . l:c_word
    setfiletype yaml.ansible
    setlocal iskeyword-=.
  endfunction

  command! AnsibleDocFilter call AnsibleDoc("filter")
  command! AnsibleDocKeyword call AnsibleDoc("keyword")
  command! AnsibleDocLookup call AnsibleDoc("lookup")
  command! AnsibleDocModule call AnsibleDoc("module")

  command! AnsibleLintFile term bash -lc "source $ANSIBLE_VENV_PATH && rm -rf ${HOME}/.cache/ansible-compat && ansible-lint --offline --force-color --config-file ${HOME}/.config/ansible-lint.yaml %:p"
  command! AnsibleLintProj term bash -lc "source $ANSIBLE_VENV_PATH && rm -rf ${HOME}/.cache/ansible-compat && ansible-lint --offline --force-color --config-file ${HOME}/.config/ansible-lint.yaml --project-dir `pwd`"

  function! AnsibleRunPlaybook(...) abort
    if a:0 != 3
      echohl WarningMsg
      echom "Usage: :AnsibleRunPlaybook <ansible_user> <limit> <playbook>"
      echohl None
      return
    endif

    let ansible_run_playbook = 'term bash -lc "source $ANSIBLE_VENV_PATH && ansible-playbook -i $ANSIBLE_COMMON_INVENTORY -i % -u ' . shellescape(a:1) . ' -l ' . shellescape(a:2) . ' ' . shellescape(a:3) . '"'
    execute ansible_run_playbook
  endfunction

  command! -nargs=* AnsibleRunPlaybook call AnsibleRunPlaybook(<f-args>)

  command! -nargs=1 BenderBuild term bash -lc "source $ANSIBLE_VENV_PATH && cd ${HOME}/projects/github/nbw74/antest && ansible-playbook -i inventory/hosts.yml -e flavour=<args> prepare.yml && ansible-bender build build.yml"

  command! YqEval vert term bash -lc "yq eval . %"
  command! YamlPy vert term bash -lc "cat % | python3 -c 'import yaml, json, sys; print(json.dumps(yaml.safe_load(sys.stdin)))' | jq -C"

  nmap <F1> :execute<CR>
  nmap <F3> :term antest.sh --from-inventory --remove<CR>
  nmap <F4> :term antest.sh --from-inventory --stop<CR>
  nmap <F5> :vert term antest.sh --from-inventory<CR>
  nmap <F7> :vert term antest.sh --from-inventory --teardown --remove<CR>
  nmap <F8> :term antest.sh --from-inventory --stop --remove<CR>
endif
" indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

map <F2> :w<CR>
imap <F2> <Esc>:w<CR>

if has("gui_running")
  " nice schemes for GUI:
  "				Dark: darkblue, desert, inkpot, jellybeans, moria
  "				Bright: default, peachpuff, zellner
  let g:lucius_style = "dark"
  let g:sierra_Sunset = 1
  let g:lucius_no_term_bg = 0
  colorscheme lucius

  autocmd FileType * hi ShowMarksHLl guifg=LightGoldenRod guibg=DarkSlateGray
  autocmd FileType * hi ShowMarksHLu guifg=MediumPurple guibg=DarkSlateGray
  autocmd FileType * hi ShowMarksHLo guifg=DarkSeaGreen guibg=DarkSlateGray
  autocmd FileType * hi ShowMarksHLm guifg=IndianRed guibg=DarkSlateGray

  set lines=50
  set columns=200

  if hostname() == 'ws2.ipbase.tech'
    set guifont=Nimbus\ Mono\ PS\ 11
  else
    set guifont=Fira\ Code\ 10
  endif

  set guioptions=acgi

  nmap <M-1> 1gt
  nmap <M-2> 2gt
  nmap <M-3> 3gt
  nmap <M-4> 4gt
  nmap <M-5> 5gt
  nmap <M-6> 6gt
  nmap <M-7> 7gt
  nmap <M-8> 8gt
  nmap <M-9> 9gt
  nmap <M-0> 10gt
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

if filereadable(expand("~/.vim/local/globalmarks.vim"))
  source <sfile>:h/.vim/local/globalmarks.vim
endif
" EOF
