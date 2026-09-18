" Keep the existing Vim runtime, plugins and filetype settings during migration.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Preserve Markdown hard breaks and code examples when saving.
autocmd! denny_vimrc BufWritePre
autocmd denny_vimrc BufWritePre * if &l:filetype !=# 'markdown' | %s/\s\+$//e | endif
