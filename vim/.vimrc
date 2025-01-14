set nocompatible              " be iMproved, required
filetype off                  " required
colorscheme desert

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'mattn/emmet-vim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-commentary'
Plugin 'Yggdroot/indentLine'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'prettier/vim-prettier', { 'do': 'yarnpkg install --frozen-lockfile --production' }
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'
Plugin 'nelsyeung/twig.vim'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'mcchrish/nnn.vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'pantharshit00/vim-prisma'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'Exafunction/codeium.vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
syntax on 

set laststatus=2

set t_Co=256

"remapping de touches
"touches f6 et F7 pour naviguer dans les onglets
map <F6> :tabp<CR>
map <F7> :tabn<CR>

"numerotation des lignes
"set number

"numerotation relative des lignes
set rnu

"on garde le curseur au centre de l'ecran
set so=999

"vim tweak
" recherche récursive dans les fichiers
set path+=**

" affiche tout les possibilitées en tab complete
set wildmenu

"recherche par tags
command! MakeTags ctags -R .

"easy indentation
set tabstop=2
set expandtab
set shiftwidth=2
set autoindent
set smartindent
" set cindent
let g:airline#extensions#tabline#enabled = 1

"powerline fonts for airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"mapping des touches sur clavier bepo
source ~/.vimrc.bepo

"autosave
":au TextChanged * :w
" :au InsertLeave * {
"   :Prettier  
"   :w
" }
" write shortcut
nnoremap nrst :w<CR>
"auto Prettier
"autocmd BufWritePre *.js,*.jsx,*.tsx :Prettier
"
"nerdtree open shortcut
nnoremap gt :NERDTreeToggle<CR>

" format on save
autocmd BufwritePre *.php :Prettier --parser=php

"disable folding in markdown files
let g:vim_markdown_folding_disabled =1

"disable syntax conceal in markdown files
let g:vim_markdown_conceallevel =0
let g:vim_markdown_concealcursor="n"

"auto change pwd dir
"let commented, it interacts with the fuzzyfinder
"set autochdir

"open fuzzyFinder
" nnoremap gq :FZF<CR>
"nnoremap gr :call fzf#run({'source': 'git ls-files', 'sink': 'e'})<CR>
nnoremap gq :call fzf#run(fzf#wrap({'source': 'git ls-files' }))<CR>
nnoremap gr :Buffers<CR>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm():"<CR>"

au BufNewFile,BufRead *.ejs set filetype=html

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
"utilisation de la souris
set mouse=a
