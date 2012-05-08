DOT_FILES=".gitconfig .gvimrc .vimrc .zshrc"
for file in $DOT_FILES; do
  ln -s ~/Documents/dotfiles/$file ~/$file
done

rm -r ~/.oh-my-zsh/custom
ln -s ~/Documents/dotfiles/oh_my_zsh/ ~/.oh-my-zsh/custom
