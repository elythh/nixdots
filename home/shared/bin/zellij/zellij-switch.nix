_: ''
  #!/usr/bin/env bash

  # Required dependencies
  #   macOS
  #   https://zellij.dev/
  #   https://github.com/ajeetdsouza/zoxide

  if [ "$1" = "-h" ] || [ "$1" == "--help" ]; then
  	printf "\n"
  	printf "\033[1m  zellij switch - create or switch between zellij sessions \033[0m\n"
  	printf "\n"
  	printf "\033[32m  Run interactive mode (prompt zellij sessions or zoxide results)\n"
  	printf "\033[34m      zellij-switch\n"
  	printf "\n"
  	printf "\033[32m  Go to session (matches zellij session, zoxide result, or path)\n"
  	printf "\033[34m      zellij-switch {name}\n"
  	printf "\n"
  	printf "\033[32m  Show help\n"
  	printf "\033[34m      zellij-switch -h\n"
  	printf "\033[34m      zellij-switch --help\n"
  	printf "\n"
  	printf "\033[32m  Inspried by\n"
  	printf "\033[37m      https://github.com/joshmedeski/t-smart-tmux-session-manager\n"
  	printf "\n"
  	exit 0
  fi

  HEADER="Current zellij sessions and zoxide entries"
  PROMPT="Pick > "

  in_zellij=$(echo $ZELLIJ)
  if [[ ! -z "$in_zellij" ]]; then
  	# detach when already in zellij
  	# kitty @ send-text \\x0fd\\n
  	# kitty @ send-text zellij-switch\\n
  	osascript <<EOF
  tell application "System Events"
      keystroke "o" using control down -- control-o
      keystroke "d" -- d
      -- delay 0.1 -- wait 10 milliseconds
      keystroke "zellij-switch"
      keystroke return
  end tell
  EOF
  	exit 0
  fi

  if [[ $# -eq 1 ]]; then
  	# assign selected to the passed argument
  	selected=$1
  else
  	# assign selected to existing zellij session
  	# or an entry from zoxide
  	selected=$(
  		(zellij list-sessions -s -n || true && zoxide query -l) | fzf \
  			--reverse \
  			--header "$HEADER" \
  			--prompt "$PROMPT"
  	)
  fi

  # exit if didn't select an entry from fzf
  if [[ -z $selected ]]; then
  	exit 0
  fi

  # if a folder, grab just the name portion
  selected_name=$(basename "$selected" | tr . _)

  # create new session or re-attach existing session
  zellij attach -c $selected_name
''
