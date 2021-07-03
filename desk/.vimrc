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
" Some language servers have issues with backup files
set nobackup
set nowritebackup
" Give more space for displaying messages
"set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to delays
set updatetime=300
au BufEnter * set noro      "Don't warn about read-only files

"Disable relative number for unfocused, insert modes
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold   :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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
  "autocmd filetype python nnoremap <silent> K :call completor#do('doc')<CR>
  "autocmd filetype python nnoremap <silent> [D :call completor#do('definition')<CR>
  "autocmd filetype python nnoremap <silent> ]D :call completor#do('definition')<CR>
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
"Plug 'tpope/vim-surround'
"Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-abolish'
"Plug 'mileszs/ack.vim'
"Plug 'maralla/completor.vim'
"Plug 'nvie/vim-flake8'
"Plug 'tell-k/vim-autopep8'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" List ends here. Plugins become visible to Vim after this call.
call plug#end()
"""""""""""""""""""""""""""""""
"Plugin: Completor.vim options:
let g:completor_python_binary = "/usr/bin/python"
