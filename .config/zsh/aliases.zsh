alias git-kak-init='systemctl --user start git-kak@$(systemd-escape $(git rev-parse --show-toplevel))'
alias git-kak='if ! kak -l | grep -q ^$(basename $(git rev-parse --show-toplevel)); then git-kak-init; fi; kak -c $(basename $(git rev-parse --show-toplevel))'
alias ls="exa --icons"
alias ncdu="ncdu --color dark"
