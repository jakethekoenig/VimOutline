#!/usr/bin/env bash

git add -A
git commit --amend
rm -rf ~/.vim/bundle/vimflowy/
vi plugin/vimflowy.vim
