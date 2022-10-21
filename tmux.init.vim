filetype plugin on

set autochdir       " auto chdir to active file
set expandtab       " Expand TABs to spaces
set number          " enable number
set omnifunc=syntaxcomplete#Complete
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set tabstop=4       " The width of a TAB is set to 4.
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m
set undofile

" persistant undo: https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
let s:undodir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "", 0700)
endif
let &undodir=s:undodir
" wsl
set clipboard+=unnamed

let g:clipboard = {
    \'name': 'wsl-clip',
    \'copy': {
    \'+': 'clip.exe',
    \'*': 'clip.exe',
    \},
    \'paste': {
    \'+': "powershell.exe Get-Clipboard",
    \'*': "powershell.exe Get-Clipboard",
    \},
    \'cache_enabled': 0,
\}

inoremap ;j      <Esc>JA
inoremap ;n      <C-n>
inoremap ;;      <C-p>
inoremap ;p      <C-r>"
inoremap ;w      <Esc>:w<CR>a
nnoremap ;3      :buffer #<cr>
nnoremap ;Q      :q!<cr>
nnoremap ;ev     :edit ~/repo/dotfiles/tmux.init.vim<cr>
inoremap ;h      <Esc>:noh<cr>i<Right>
nnoremap ;h      :noh<cr>
nnoremap ;g      :silent !tmux popup -d $(pwd) -w 90\% -h 90\% -E lazygit -ucf ~/repo/dotfiles/tmux.lazygit.config.yaml<cr>
nnoremap ;j      J
nnoremap ;q      :q<cr>
nnoremap ;sn     :set number<cr>
nnoremap ;sv     :w<cr>:source ~/repo/dotfiles/tmux.init.vim<cr>
nnoremap ;w      :w<cr>
nnoremap ;r      :w<cr>:silent !tmux select-pane -R \; send-keys Up Enter \; select-pane -L<cr>
inoremap ;r      <Esc>:w<cr>:silent !tmux select-pane -R \; send-keys Up Enter \; select-pane -L<cr>a

nnoremap Q       q
nnoremap q       :q<cr>
nnoremap s       <nop>
inoremap ;sf      <Esc>/
nnoremap sf      /
nnoremap sb      ?

nnoremap <bs>    <c-b>zz
nnoremap <space> <c-f>zz

nnoremap J       }zz
nnoremap K       {zz
nnoremap j       j<c-e>
nnoremap k       k<c-y>

hi CursorLine    cterm=NONE ctermbg=242      ctermfg=white guibg=darkgray
hi Visual                   ctermbg=darkred 
set cursorline

" Change Color when entering Insert Mode
autocmd InsertEnter * highlight  CursorLine ctermfg=white ctermbg=darkgray
" autocmd NormalEnter * highlight  CursorLine ctermfg=white guibg=darkgray

" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight  CursorLine ctermfg=white guibg=blue

if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif

" test area
" 
