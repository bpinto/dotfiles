DOT_FILES=".gvimrc .vimrc .zshrc"
for file in $DOT_FILES; do
  ln -s ~/Documents/dotfiles/$file ~/$file
done
