" Author: Yang Zhang <zyzy0723@gmail.com>"

""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""


set nocompatible                    " Use Vim Settings (Not Vi). This must be first, because it changes other options as a side effect.
syntax on


" Environment: f[[
if exists('$TMUX')                 " fix keymap under screen
        "let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        "let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    " tmux will send xterm-style keys when its xterm-keys option is on
    exec "set <xUp>=\e[1;*A"
    exec "set <xDown>=\e[1;*B"
    exec "set <xRight>=\e[1;*C"
    exec "set <xLeft>=\e[1;*D"
    "map [F $
    "imap [F $
    "map [H g0
    "imap [H g0
"else
    "let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    "let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Note: xterm color names: http://mkaz.com/solog/system/xterm-colors.html
let color_normal = 'HotPink'
let color_insert = 'RoyalBlue1'
let color_exit = 'green'
if &term =~ 'xterm\|rxvt'
        exe 'silent !echo -ne "\e]12;"' . shellescape(color_normal, 1) . '"\007"'
        let &t_SI="\e]12;" . color_insert . "\007"
        let &t_EI="\e]12;" . color_normal . "\007"
"        exe 'autocmd VimLeave * :!echo -ne "\e]12;"' . shellescape(color_exit, 1) . '"\007"'
elseif &term =~ "screen"
        if exists('$TMUX')
                exe 'silent !echo -ne "\033Ptmux;\033\e]12;"' . shellescape(color_normal, 1) . '"\007\033\\"'
                let &t_SI="\033Ptmux;\033\e]12;" . color_insert . "\007\033\\"
                let &t_EI="\033Ptmux;\033\e]12;" . color_normal . "\007\033\\"
"                exe 'autocmd VimLeave * :!echo -ne "\033Ptmux;\033\e]12;"' . shellescape(color_exit, 1) . '"\007\033\\"'
        else
                exe 'silent !echo -ne "\033P\e]12;"' . shellescape(color_normal, 1) . '"\007\033\\"'
                let &t_SI="\033P\e]12;" . color_insert . "\007\033\\"
                let &t_EI="\033P\e]12;" . color_normal . "\007\033\\"
"                exe 'autocmd VimLeave * :!echo -ne "\033P\e]12;"' . shellescape(color_exit, 1) . '"\007\033\\"'
        endif
endif
unlet color_normal | unlet color_insert | unlet color_exit

if ! has("gui_running")                " fix alt key under terminal
        for i in range(48, 57) + range(65, 90) + range(97, 122)
                exe "set <A-" . nr2char(i) . ">=" . nr2char(i)
        endfor
endif
set shell=zsh\ -f
let g:my_term = 'urxvt'                " for plugins to open window
set iskeyword+=%,&,?,\|,\\,!
set isfname-==
set grepprg=grep\ -nH\ $*
set t_vb=                              " shut up bell
set confirm
set shortmess+=s
set fileencodings=ucs-bom,utf8,cp936,big5,euc-jp,euc-kr,gb18130,latin1
set viewoptions=folds,options,cursor,slash,unix
set virtualedit=onemore
scriptencoding utf-8
set ttyfast
"let g:html_dynamic_folds = 1
"set lazyredraw

" --------------------------------------------------------------------- f]]
" UI: f[[
set background=light
if has("gui_running")                  " for gvim
        set antialias                      " font antialias
        set guifont=inconsolata\ 13
        "set guifont=Monospace\ 12
        set guifontwide=WenQuanYi\ Micro\ Hei\ 13
        set guioptions=aegi                " cleaner gui
        set linespace=3
        set background=dark
        "colo wombat256
        "colo molokai
        colo bocau
        hi CursorColumn guibg=Green
        hi Matchmaker guibg=#333
endif
set t_Co=256
au BufEnter * if &buftype == "quickfix" | syn match Error "error:" | endif
hi Search guibg=#8ca509
hi LineNr ctermfg=134 guifg=#d426ff
hi VertSplit ctermbg=none ctermfg=55 cterm=none guifg=purple
hi CursorLineNr ctermfg=red
hi Statement ctermfg=3
hi Visual ctermbg=81 ctermfg=black cterm=none
hi MatchParen ctermbg=yellow ctermfg=black
hi Pmenu ctermfg=81 ctermbg=16
hi Cursorline ctermfg=117 cterm=italic guifg=Cyan
hi Comment ctermfg=blue guifg=#145ecc
hi Search ctermfg=red ctermbg=cyan
hi DiffAdd ctermbg=none ctermfg=LightBlue
hi DiffChange ctermbg=none ctermfg=yellow
hi DiffText ctermbg=none ctermfg=55
let g:zenburn_high_Contrast = 1

" Highlight Class and Function names
func! HighlightClasses()
        syn match cCustomClass     "\w\+\s*\(::\)\@="
        hi def link cCustomClass     cppType
endfunc
au syntax * call HighlightClasses()

" Spell Check:
hi clear SpellBad
hi SpellBad term=standout term=underline cterm=italic ctermfg=none ctermbg=black
hi clear SpellCap
hi SpellCap term=standout term=underline cterm=italic ctermfg=Blue
hi clear SpellLocal
hi SpellLocal term=standout term=underline cterm=italic ctermfg=Blue
hi clear SpellRare
hi SpellRare term=standout term=underline cterm=italic ctermfg=Blue
" Statusline Highlight:
au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
let g:tex_conceal='adgmb'

set mouse=a
set showcmd                            " display incomplete commands right_bottom
set numberwidth=1
au InsertEnter * set number
set ruler
set rulerformat=%35(%=%r%Y\|%{&ff}\|%{strlen(&fenc)?&fenc:'none'}\ %m\ %l/%L%)
"let &statusline="%<[%{substitute(getcwd(), expand(\"$HOME\"), '~', 'g')}]\ %f\ %=%r%Y\|%{&ff}\|%{strlen(&fenc)?&fenc:'none'}\ %l/%L"
"set statusline+=%#warningmsg#
"set statusline+=%*
set laststatus=2

let g:Powerline_theme='custom'
let g:Powerline_symbols = 'compatible'
let g:Powerline_cache_dir = $HOME . '/.vimtmp/'
let g:Powerline_stl_path_style = 'relative'
let g:Powerline_symbols_override = { 'LINE': ''}
let g:loaded_syntastic_plugin = 0      " disable powerline syntastic
let g:Powerline_mode_n = 'N'
let g:Powerline_mode_i = 'I'
let g:Powerline_mode_v = 'V'
let g:Powerline_mode_V = 'VL'
let g:Powerline_mode_cv= 'VB'
let g:Powerline_mode_R = 'R'
let g:Powerline_mode_s = 'S'
let g:Powerline_mode_S = 'SL'
let g:Powerline_mode_cs= 'SB'
set noshowmode

set scrolljump=5                       " lines to scroll with cursor
set scrolloff=5                        " minimum lines to keep at border
set sidescroll=3
set sidescrolloff=3
set nowrap                             " do not wrap long lines
set whichwrap=b,s,<,>,[,]
"set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set fillchars=vert:*,fold:-,diff:-
if v:version > 703 || has("patch541")
        set formatoptions+=nMjm            " m: linebreak for Chinese
else
        set formatoptions+=nMm
endif
set splitright splitbelow
set backspace=indent,eol,start         " allow backspace over everything
set smarttab
set autoindent smartindent
set textwidth=100
set tabstop=4 softtabstop=4 shiftwidth=4
set showmatch matchtime=0

set ignorecase smartcase incsearch hlsearch
set magic                              " for regular expressions
xnoremap / <Esc>/\%V
" use /[^\x00-\x7F] to search multibytes
" ---------------------------------------------------------------------f]]
" History:
set nobackup noswapfile
set history=200                        " command line history
if has('persistent_undo')
        set undofile                       " keep an undo record separately for every file
        set undolevels=200
        set undodir=~/.vimtmp/undo
endif
set viminfo+=n$HOME/.vimtmp/viminfo
au CursorHold,CursorHoldI,BufEnter,WinEnter * checktime
set autoread                           " auto reload file when changes have been detected
set updatetime=500                     " time threshold for CursorHold event

" ---------------------------------------------------------------------
" Basic Maps:
let mapleader=" "
let maplocalleader=","
set timeoutlen=300                     " wait for ambiguous mapping
set ttimeoutlen=0                      " wait for xterm key escape
inoremap <c-\> <Esc>
vnoremap <c-\> <Esc>
"inoremap <Esc> <Esc>
inoremap jj <ESC>
nnoremap ; :
command! -bang -nargs=* Q q<bang>
command! -bang -nargs=* -complete=file W w<bang> <args>
command! -bang -nargs=* -complete=file Wq wq<bang> <args>
command! -bang -nargs=* -complete=file WQ wq<bang> <args>
nnoremap <Tab> i<Tab><Esc>
nnoremap <S-Tab> ^i<Tab><Esc>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cmap cd. lcd %:p:h
cmap w!! SudoWrite %
nnoremap "gf <C-W>gf
" disable ex mode and help
nnoremap Q <Esc>
nnoremap <F1> :echo<CR>
inoremap <F1> <C-o>:echo<CR>

vnoremap <expr> I ForceBlockwiseVisual('I')
vnoremap <expr> A ForceBlockwiseVisual('A')
func! ForceBlockwiseVisual(key)
        if mode () == 'v'
                return "\<C-v>". a:key
        elseif mode () == 'V'
                return "\<C-v>0o$". a:key
        else | return a:key | endif
endfunc
" ---------------------------------------------------------------------
" Clipboard:                           " + register may be wrong under xterm
nnoremap Y y$
set pastetoggle=<F12>                  " toggle paste insert mode
xnoremap <c-c> "+y
inoremap <c-v> <Esc>:set paste<CR>"+p:set nopaste<CR>a
inoremap <Leader><c-v> <Esc>:r !xsel -o -p<CR>
" insert word of the line above
inoremap <C-Y> <C-C>:let @z = @"<CR>mz
                        \:exec 'normal!' (col('.')==1 && col('$')==1 ? 'k' : 'kl')<CR>
                        \:exec (col('.')==col('$') - 1 ? 'let @" = @_' : 'normal! yw')<CR>
                        \`zp:let @" = @z<CR>a
" delete to blackhole register
nnoremap <Del> "_x
xnoremap <Del> "_d
xnoremap p "_dp
" ---------------------------------------------------------------------
" Folding:
set foldmethod=marker
set foldmarker=f[[,f]]
set foldnestmax=2                      " nesting
set foldminlines=5
"set foldcolumn=0
"set diffopt=filler,foldcolumn:0
nnoremap zo zO

" ---------------------------------------------------------------------
" QuickFix:
set switchbuf=split
func! QuickfixToggle()
        for i in range(1, winnr('$'))
                if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
                        cclose | lclose
                        return
                endif
        endfor
        copen
endfunc
nnoremap <Leader>q :call QuickfixToggle()<CR>

" ---------------------------------------------------------------------
set expandtab
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'


" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
Plugin 'pydiction'
" Git plugin not hosted on GitHub


" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
filetype plugin on

let g:pydiction_location = '/home/yang/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 3

"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line




