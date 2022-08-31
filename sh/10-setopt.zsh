# background job
setopt long_list_jobs
setopt notify
setopt no_hup
# cd
setopt auto_cd
# setopt auto_pushd
setopt pushd_ignore_dups
# completion
setopt hash_list_all
setopt complete_in_word
setopt glob
setopt extended_glob
setopt no_glob_dots
# history
setopt append_history
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
# zle
setopt no_beep
setopt unset
setopt interactive_comments
## try to avoid the 'zsh: no matches found...'
setopt no_no_match
## add `|' to output redirections in the history
setopt hist_allow_clobber
## warning if file exists ('cat /dev/null > ~/.zshrc')
setopt no_clobber
