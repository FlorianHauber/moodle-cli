#!/bin/sh
# Installs `moodle` into ~/.local/bin — no root needed.
set -e
command -v python3 >/dev/null 2>&1 || { echo "python3 not found (on Arch it's the 'python' package)"; exit 1; }
DIR="$HOME/.local/bin"
mkdir -p "$DIR"
install -m 755 "$(dirname "$0")/moodle" "$DIR/moodle"
echo "installed: $DIR/moodle  ($("$DIR/moodle" --version))"
case ":$PATH:" in
  *":$DIR:"*) ;;
  *) echo
     echo "~/.local/bin is not on your PATH yet. Add this line to ~/.bashrc (or ~/.zshrc):"
     echo '  export PATH="$HOME/.local/bin:$PATH"'
     echo "then open a new terminal." ;;
esac
echo; echo "Start with:  moodle login"
