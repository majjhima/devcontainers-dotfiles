" Plugins
filetype on
filetype off
call plug#begin()

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
if executable('ack-grep')
  let g:ackprg="ack-grep -H --nocolor --nogroup --column"
  Plug 'mileszs/ack.vim'
elseif executable('ack')
  Plug 'mileszs/ack.vim'
elseif executable('ag')
  Plug 'mileszs/ack.vim'
  let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
endif

" General
Plug 'preservim/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'jistr/vim-nerdtree-tabs'
if v:version >= 702
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'nathanaelkane/vim-indent-guides'
endif
Plug 'vim-scripts/restore_view.vim'
if v:version >= 703
  Plug 'easymotion/vim-easymotion'
  Plug 'myusuf3/numbers.vim'
  Plug 'mbbill/undotree'
endif
" NerdTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" General Programming
Plug 'vim-syntastic/syntastic'
if executable('git')
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
endif
Plug 'preservim/nerdcommenter'
Plug 'godlygeek/tabular'

" Misc
Plug 'tpope/vim-markdown'
Plug 'greyblake/vim-preview'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'LunarWatcher/auto-pairs'

" Python
Plug 'vim-scripts/python_match.vim'
Plug 'vim-scripts/pythoncomplete'

" Javascript
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'briancollins/vim-jst'
Plug 'kchmck/vim-coffee-script'

" Scala
Plug 'derekwyatt/vim-scala'
Plug 'derekwyatt/vim-sbt'

" HTML
Plug 'heracek/HTML-AutoCloseTag'
Plug 'hail2u/vim-css3-syntax'
Plug 'tpope/vim-haml'

" Sudo support
Plug 'chrisbra/SudoEdit.vim'
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" && bufname("") !~ "^sudo:" | lcd %:p:h | endif

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required

" Brief help
" :PlugList       - lists configured plugins
" :PlugInstall    - installs plugins; append `!` to update or just
" :PlugUpdate
" :PlugSearch foo - searches for foo; append `!` to refresh local cache
" :PlugClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h plug for more details or wiki for FAQ

" General
set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
set nocompatible
set showmode

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8              " better default than latin1
  setglobal fileencoding=utf-8    " change default file encoding when writing new files
endif

set viewoptions=cursor,folds,slash,unix
let g:skipview_files = ['*\.vim']

" Mouse improvements
set mouse=nv
set mousehide               " Hide the mouse cursor while typing
"nmap <leader><LeftMouse> <C-T>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set virtualedit=block
set spell                   " Spell checking on
set hidden                  " Allow buffer switching without saving
set cursorline              " Highlight current line
highlight clear SignColumn  " SignColumn should match background for things like vim-gitgutter

" Sets how many lines of history VIM has to remember
set history=700

" Backups are nice ...
set backup
if has('persistent_undo')
  set undofile                " So is persistent undo ...
  set undolevels=1000         " Maximum number of changes that can be undone
  set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"Always show current position
set ruler
if has('cmdline_info')
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd                 " Show partial commands in status line and
                              " Selected characters/lines in visual mode
endif

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on

" Allow the left and right arrow keys to traverse lines
set whichwrap+=<,>,h,l

" Common autocorrections
ab teh the
ab fro for

" Stupid shift key fixes
if has("user_commands")
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif

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
"colorscheme murphy
"colorscheme desert

if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

let g:airline_theme='badwolf'
"unlet g:airline_powerline_fonts
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
scriptencoding utf-8

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

" Strip whitespace {
function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

augroup vimrc_autocmds
  " Set gitcommit right margin to 120, but highlight at 72
  autocmd FileType gitcommit set textwidth=120
  autocmd FileType gitcommit autocmd BufEnter * highlight OverLength ctermbg=LightMagenta
  autocmd FileType gitcommit autocmd BufEnter * match OverLength /\%72v.*/
  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
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
  " check perl code with :make
  autocmd FileType perl set makeprg=perl\ -c\ %\ $*
  autocmd FileType perl set errorformat=%f:%l:%m
  autocmd FileType perl set autowrite
  " Use real tabs in Makefiles
  autocmd FileType make setlocal noexpandtab
  autocmd FileType make setlocal nosmarttab
  autocmd FileType make setlocal shiftwidth=8
  autocmd FileType make setlocal softtabstop=0
  " Remove trailing whitespaces and ^M chars on save
  autocmd FileType cpp,cs,go,html,java,javascript,js,perl,php,php,python,python,ruby,sh,twig,vc,vim,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
augroup END

" Syntastic options
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--max-line-length 120'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open=1
let g:syntastic_loc_list_height=5

" show matching brackets
set showmatch
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

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

" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

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

set t_kb=

" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
" }

call InitializeDirectories()
