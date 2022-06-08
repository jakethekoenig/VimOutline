#!/usr/bin/env bash

git add -A
git commit --amend --no-edit
rm -rf ~/.vim/bundle/VimOutline/
vi +PluginInstall +qall
vi -O autoload/vimoutline.vim ftplugin/outline_settings.vim ftplugin/outline_mappings.vim
