set nocompatible
set showmode

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
endif

set viewoptions=cursor,folds,slash,unix
let g:skipview_files = ['*\.vim']

" Mouse improvements
set mouse=nv
"nmap <leader><LeftMouse> <C-T>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set virtualedit=block

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Allow the left and right arrow keys to traverse lines
set whichwrap+=<,>,h,l

" Common autocorrections
ab teh the
ab fro for

" Set max tabs to show
set tabpagemax=30

" Disable folding
set nofoldenable

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :nohlsearch<CR><CR>

" GitGutter
let g:gitgutter_max_signs=2000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

map <Leader>g :let &background = ( &background == "dark"? "light" : "dark" )<CR>
set background=dark
"set background=light
"let g:solarized_termcolors=16
"colorscheme solarized
colorscheme murphy
"colorscheme desert

let g:airline_theme='badwolf'
unlet g:airline_powerline_fonts
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_linecolumn_prefix = '¶ '
let g:airline_branch_prefix = '⎇ '
let g:airline_paste_symbol = 'ρ'
let g:airline_section_c='%F%m'
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

hi statusline ctermfg=black ctermbg=lightgreen
"hi statusline ctermfg=white ctermbg=cyan

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces, but true tab characters are still 8 spaces wide
set shiftwidth=4
set softtabstop=4
set tabstop=8

" Use real tabs in Makefiles
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal nosmarttab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=0

" Linebreak on 500 characters
"set lbr
"set tw=500

set noautoindent
set nosmartindent

set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0

augroup vimrc_autocmds
    " Set gitcommit right margin to 120, but highlight at 72
    autocmd FileType gitcommit set textwidth=120
    autocmd FileType gitcommit autocmd BufEnter * highlight OverLength ctermbg=LightMagenta
    autocmd FileType gitcommit autocmd BufEnter * match OverLength /\%72v.*/
    " Show a visual right margin at 120 characters for Python and Ruby
    autocmd FileType python,ruby autocmd BufEnter * highlight OverLength ctermbg=LightMagenta
    autocmd FileType python,ruby autocmd BufEnter * match OverLength /\%120v.*/
    autocmd FileType python,ruby map <buffer> <F7> :lclose<CR>
    autocmd FileType python,ruby autocmd BufReadPost quickfix map <buffer> <F7> :lclose<CR>
    autocmd FileType python,ruby map <buffer> <F8> :lopen 5<CR>
    autocmd FileType python,ruby map <buffer> <F9> :lprevious<CR>
    autocmd FileType python,ruby map <buffer> <F10> :ll<CR>
    autocmd FileType python,ruby map <buffer> <F11> :lnext<CR>
    autocmd FileType json,ruby,yaml set shiftwidth=2
    autocmd FileType json,ruby,yaml set softtabstop=2
augroup END

" Syntastic options
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--max-line-length 120'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open=1
let g:syntastic_loc_list_height=5

" show matching brackets
set showmatch

" show line numbers
"autocmd FileType perl,python set number

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Make tab in v mode indent code
vmap <tab> >gv
vmap <s-tab> <gv

" Make tab in normal mode indent code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" I like Y the way it is
nnoremap Y Y

" Paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F7>

" Make j and k move screen up and down one line without shifting
" the relative cursor position.
nmap j 10<C-D>
nmap k 10<C-U>

set scrolljump=1    " Lines to scroll when cursor leaves screen
set scrolloff=20    " Minimum lines to keep above and below cursor

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <down> gj
noremap <up> gk

" Easy toggle for relative line numbers.
nnoremap <F2> :set invnumber<CR>
nnoremap <F3> :NumbersToggle<CR>
let g:enable_numbers = 0

" press gi followed by a character will insert that character at cursor
"map gi i<space><esc>r

" these two maps enable you to press space to move cursor down a screen,
" and press backspace up a screen.
"map <space> <c-f>
"map <backspace> <c-b>

" CtrlP settings
" Use a leader instead of the actual named binding
nmap <LEADER>p :CtrlP<CR>
" Easy bindings for its various modes
nmap <LEADER>bb :CtrlPBuffer<CR>
nmap <LEADER>bm :CtrlPMixed<CR>
nmap <LEADER>bs :CtrlPMRU<CR>

" Easier ways to switch buffers
"nnoremap <F4> :buffers<CR>:buffer<Space>
nnoremap <F4> :BuffergatorToggle<CR>
map <F5> :BuffergatorMruCyclePrev<CR>
map <F6> :BuffergatorMruCycleNext<CR>
nmap [b :bp<CR>
nmap ]b :bn<CR>

" Buffergator
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'
" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1
" Looper buffers
"let g:buffergator_mru_cycle_loop = 1
" View the entire list of buffers open
nmap <LEADER>bg :BuffergatorToggle<CR>
" Open new buffer in current window
nmap <LEADER>B :enew<CR>
" Open new buffer in vertical split
map <c-w>N :vnew<CR>
" Close the current buffer and move to the previous one
nmap <leader>bq :bp <BAR> bd #<CR>

" quicker way to save
"map <F2> :w<CR>
"map <F4> :wq<CR>

" You can use - to jump between windows
"map - <c-w>w

" Turn off autoclose of quotes for vim files
"let g:autoclose_vim_commentmode = 1
"nmap <Leader>' <Plug>ToggleAutoCloseMappings
" The auto-pairs plugin is more intelligent than autoclose
let g:AutoPairsShortcutToggle = '<C-p>'
let g:AutoPairsShortcutFastWrap = '<C-e>'
let g:AutoPairsShortcutJump = '<C-n>'
"let g:AutoPairsShortcutBackInsert = '<C-b>'

" Turn off autoformatting of the "o" command
set formatoptions=crql

" Remove trailing whitespace on save
autocmd FileType sh,perl,python,ruby,html,js,php,vim,csv autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd BufWritePre *.stanza :%s/\s\+$//e

set t_kb=
