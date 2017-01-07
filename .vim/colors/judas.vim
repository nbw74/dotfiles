" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2006 Dec 10

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "judas"
hi Normal		  guifg=black  guibg=#f0f0f0
hi Scrollbar	  guifg=darkcyan guibg=cyan
hi Menu			  guifg=black guibg=cyan
hi SpecialKey	  term=bold  cterm=bold  ctermfg=00  guifg=AntiqueWhite3
hi NonText		  term=bold  cterm=bold  ctermfg=00  gui=bold      guifg=AntiqueWhite3
hi Directory	  term=bold  cterm=bold  ctermfg=brown  guifg=#cc8000
hi ErrorMsg		  term=standout  cterm=bold  ctermfg=grey  ctermbg=red  guifg=red1  guibg=bg
hi Search		  term=reverse  ctermfg=white  ctermbg=red  gui=bold  guifg=white  guibg=coral3
hi MoreMsg		  term=bold  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=SeaGreen
hi ModeMsg		  term=bold  cterm=bold  guifg=Red	guibg=bg
hi LineNr		  term=underline  cterm=bold  ctermfg=00 guifg=AntiqueWhite3
hi Question		  term=standout  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=Green
hi StatusLine	  term=bold,reverse  cterm=none ctermbg=090 guifg=gainsboro guibg=gray24
hi StatusLineNC   term=reverse	ctermfg=white ctermbg=lightblue guifg=honeydew1 guibg=gray24
hi Title		  term=bold  cterm=bold  ctermfg=darkmagenta  gui=bold	guifg=Magenta
hi Visual		  term=reverse	cterm=reverse  gui=reverse
hi WarningMsg	  term=standout  cterm=bold  ctermfg=darkred guifg=Red
hi Cursor		  guifg=bg	guibg=Gray24
hi Comment		  term=bold  cterm=bold ctermfg=84  guifg=Ivory4
hi Constant		  term=underline  cterm=bold ctermfg=darkred  guifg=DeepPink3
hi Special		  term=bold  cterm=bold ctermfg=red  guifg=Red1
hi Identifier	  term=underline   ctermfg=brown  gui=bold guifg=turquoise4
hi Statement	  term=bold  cterm=bold ctermfg=brown	gui=bold  guifg=DarkGoldenrod3
hi PreProc		  term=underline  cterm=bold ctermfg=025   guifg=cyan4
hi Type			  term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=IndianRed3
hi Error		  term=reverse	ctermfg=darkcyan  ctermbg=black  guifg=Red	guibg=Black
hi Todo			  term=standout  ctermfg=black	ctermbg=darkcyan  guifg=Blue  guibg=Yellow
hi CursorLine	  term=underline  guibg=#555555 cterm=underline
hi CursorColumn	  term=underline  guibg=#555555 cterm=underline
hi MatchParen	  term=reverse  ctermfg=blue gui=bold guifg=bg guibg=DeepPink2
hi TabLine		  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
hi TabLineFill	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
hi TabLineSel	  term=reverse	ctermfg=white ctermbg=lightblue guifg=white guibg=blue
hi link IncSearch		Visual
hi String		  term=underline  cterm=bold ctermfg=darkmagenta  guifg=DarkOrchid
hi link Character		Constant
hi Number		  term=underline  cterm=bold ctermfg=00  guifg=Coral3
hi Boolean		  term=underline  cterm=bold ctermfg=red guifg=#ffa0a0
hi Float		  term=underline  cterm=bold ctermfg=lightgreen  guifg=#ffa0a0
hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi Label		  term=bold  cterm=bold ctermfg=brown	gui=bold  guifg=green1
hi Operator		  term=bold  cterm=bold ctermfg=brown	gui=bold  guifg=turquoise4
hi link Keyword			Statement
hi Exception	  term=bold  cterm=bold ctermfg=brown	gui=bold  guifg=green1	
hi Include		  term=underline  ctermfg=red   guifg=#ff80ff
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special

hi User1		  term=inverse,bold  cterm=inverse,bold ctermfg=red  guifg=red  guibg=honeydew1
