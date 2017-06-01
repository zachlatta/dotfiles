set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'junegunn/goyo.vim'

call vundle#end()
filetype plugin indent on

" Two space indent
set shiftwidth=2
set softtabstop=2

" 80 character line wrap
set textwidth=80 " automatically wrap lines at 80 characters
set colorcolumn=81 " draw a column at 81 chars to visually show line limit

" configure settings for editing text files
function SetTextEditingConfig()
  " setup spell checking
  set spell spelllang=en
  set spellfile=$HOME/.vim/spell/en.utf-8.add

  " disable line wrapping & color column
  set textwidth=0
  set colorcolumn=0

  " wrap at words, not at characters
  set linebreak

  " turn on Goyo
  Goyo

  " quit the buffer when we quit Goyo (so when the user presses :q or :wq)
  autocmd! User GoyoLeave nested quit
endfunction

autocmd BufRead,BufNewFile md,markdown,*.md call SetTextEditingConfig()

syntax enable
set background=dark
colorscheme solarized
