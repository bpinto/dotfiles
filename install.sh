#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )

DOT_FILES=".ackrc .editrc .gitconfig .gitignore .gvimrc .irbrc .vimrc"
for file in $DOT_FILES; do
  ln -s $DIR/$file ~/$file
done

ln -s $DIR/config.fish ~/.config/fish/config.fish
