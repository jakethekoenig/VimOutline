#!/usr/bin/env bash

git add -A
git commit --amend --no-edit
rm -rf ~/.vim/bundle/vimflowy/
vi +PluginInstall +qall
vi -O plugin/vimoutline.vim ftplugin/vimoutline.vim
