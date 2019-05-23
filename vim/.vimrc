if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
endif

" vi compatibility
set nocompatible
filetype off

" Vundle & set runtime path 
let vundle_installed=0
if !isdirectory(s:editor_root . '/bundle/Vundle.vim')
    echo "Installing Vundle"
    silent call mkdir(s:editor_root . '/bundle', "p")
    silent execute "!git clone https://github.com/VundleVim/Vundle.vim.git " . s:editor_root . "/bundle/Vundle.vim"
    let vundle_installed=1
endif
let &rtp = &rtp . ',' . s:editor_root . '/bundle/Vundle.vim'
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'valloric/youcompleteme'
Plugin 'godlygeek/tabular'
Plugin 'johngrib/vim-game-code-break'

if has('nvim')
    Plugin 'huawenyu/neogdb.vim'
endif

call vundle#end()

if vundle_installed == 1
    echo "Installing Plugins"
    :PluginInstall
endif

filetype plugin indent on

" ctrl-p settings
let g:ctrlp_working_path_mode = 'ra'

" Line Numbers
set number

" Allow usage of hidden buffers without error messages
set hidden

" Command line completion
set wildmenu

" Case sensitivity
set ignorecase
set smartcase

" Time out on keycodes, but not mappings
set notimeout ttimeout ttimeoutlen=200

" Indenting
set autoindent

" Set Tab Spacing
set tabstop=4
set shiftwidth=4

" expand tabs to 4 spaces
set expandtab

" add vimball
packadd vimball

"""""""""""""""""""""
"Keybinds
"""""""""""""""""""""
" Set Y to be more consistent with D
" (Copy to end of line)
nnoremap Y y$

nnoremap <C-L> :noh<CR>
