FILES=".gvimrc .vimrc .zshrc"
for file in $FILES; do
  ln -s ~/Documents/dotfiles/$file ~/$file
done
