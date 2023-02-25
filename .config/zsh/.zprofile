#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

#-------------------------------------------------------------------------------
#               $PATH Updates
#-------------------------------------------------------------------------------
# NOTE: this is here because it must be loaded after homebrew is added to the
# path which is done in the .zprofile which loads after the .zshenv

# MacOS ships with an older version of Ruby which is built against an X86
# system rather than ARM i.e. for M1+. So replace the system ruby with an
# updated one from Homebrew and ensure it is before /usr/bin/ruby
# Prepend to PATH
export BREW_PREFIX="$(brew --prefix)"
path=(
  "$BREW_PREFIX/opt/ruby/bin"
  "$BREW_PREFIX/lib/ruby/gems/3.0.0/bin"
  # NOTE: Add coreutils which make commands like ls run as they do on Linux rather than the BSD flavoured variant macos ships with
  "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
  $path
)

export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
