#!/bin/bash

# bash
cat >> ~/.bash_aliases <<EOF
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias watch-nvidia-smi='watch -n 1 -d -t nvidia-smi'
EOF

# tmux
cat >> ~/.tmux.conf <<EOF
set -g prefix C-j
unbind C-b
bind C-j send-prefix

set -g base-index 1
set -g status-right "%H:%M"
set -g window-status-current-style "underscore"
set -g default-terminal "screen-256color"
EOF

# emacs
mkdir -p ~/.emacs.d
cat >> ~/.emacs.d/init.el <<EOF
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(menu-bar-mode -1)
(tool-bar-mode 0)
EOF
