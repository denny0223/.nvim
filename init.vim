" Keep the existing Vim runtime, plugins and filetype settings during migration.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
