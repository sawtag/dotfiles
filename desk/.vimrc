"Simple stuff
set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8

"runtime macros/matchit.vim
packadd! matchit  "Enable matchit plugin for enhanced '%' functionality
set ruler
set number relativenumber
set hidden
set history=3000
set timeoutlen=1000         "Timeout (ms) for mappings
set ttimeoutlen=10          "Timeout (ms) for key codes
set shortmess+=A            "Don't warn about swp files
set noswapfile              "Don't create swap files
au BufEnter * set noro      "Don't warn about read-only files

"Disable relative number for unfocused, insert modes
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"Tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

"Menu
set showcmd
set wildmenu
set wildmode=longest,list,full

"Search
set hlsearch
set incsearch
"set ignorecase

""Formatting
set autoindent
"Don't treat leading zeros as Octal numbers when using <C-a> & <C-x>
set nrformats-=octal
set backspace=indent,eol,start
"Automatically wrap words that go beyond 80 chars
"set textwidth=80
"Show a red col at 80 chars
"set cc=79
"Folding options. Good for python
"set foldmethod=indent
"set foldlevel=99
highlight Folded ctermbg=Black ctermfg=Yellow
nnoremap <space> za

"Insert current date and time:
nnoremap <F2> "=strftime("%Y-%b-%d @ %T")<CR>P
inoremap <F2> <C-R>=strftime("%Y-%b-%d @ %T")<CR> 

"Easy buffer movements
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

"Easy arglist movements
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>

"Easy quicklist movements
nnoremap <silent> [c :cprevious<CR>
nnoremap <silent> ]c :cnext<CR>
nnoremap <silent> [C :cfirst<CR>
nnoremap <silent> ]C :clast<CR>

"Easy ctags movements
nnoremap <silent> [t :tprevious<CR>
nnoremap <silent> ]t :tnext<CR>
nnoremap <silent> [T :tfirst<CR>
nnoremap <silent> ]T :tlast<CR>

"Empty line without going to insert mode
nnoremap <silent> [o :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent> [O :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent> <C-l> :<C-u>noh<CR><C-l>

"* and # search selection in Visual mode
"xnoremap means visual mode and NOT select mode
"Goes into expr mode in search bar, then uses sub & escape functions to search
"from @s, @/ is used to shorten full expression and escape all common special chars
"gv - selects last selection (which is current)
""sy - yank into reg s
"the '.' is for combining texts
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

"Make & behave like :&&. & alone ignores flags, :&& uses last flags used
nnoremap & :&&<CR>
xnoremap & :&&<CR>

"ctags shortcut for code index
nnoremap <F5> :silent !ctags -R<CR>:redraw!<CR>

"Insert date and time:
nnoremap <C-h> "=strftime('%Y %b %d @ %T')<CR>p
inoremap <C-h> <C-r>=strftime('%Y %b %d @ %T')<CR>

"Enable all Pyth syntax highlghts features
let python_highlight_all = 1

"Specific file settings
if has("autocmd")
  filetype on
  autocmd filetype python setlocal ts=4 sts=4 sw=4 et cc=80 tw=79 et ai ff=unix
  "autocmd filetype python nnoremap <F8> :update <bar> :!python3 %<CR>
  autocmd filetype python noremap <buffer> <F8> :call Autopep8()<CR>
  autocmd filetype python nnoremap <silent> K :call completor#do('doc')<CR>
  autocmd filetype python nnoremap <silent> [D :call completor#do('definition')<CR>
  autocmd filetype python nnoremap <silent> ]D :call completor#do('definition')<CR>
  autocmd filetype python nnoremap <F6> :update <bar>
        \:let temp = &splitright<bar>
        \:setlocal splitright<bar>
        \:vertical term python3 %<CR>
        "\:<C-w>h
        \:let &splitright = temp<CR>
endif
"TODO: Have a makeprg section and instead call :make % with <F6> for all files

"Save root files
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

"""""""""""""""""""""""""""""""
"Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-surround'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-abolish'
Plug 'mileszs/ack.vim'
Plug 'maralla/completor.vim'
Plug 'nvie/vim-flake8'
"Plug 'tell-k/vim-autopep8'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()
"""""""""""""""""""""""""""""""
"Plugin: Completor.vim options:
let g:completor_python_binary = "/usr/bin/python"
