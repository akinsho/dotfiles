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
path=(
  "$(brew --prefix)/opt/ruby/bin"
  "$(brew --prefix)/lib/ruby/gems/3.0.0/bin"
  # NOTE: Add coreutils which make commands like ls run as they do on Linux rather than the BSD flavoured variant macos ships with
  "$(brew --prefix)/opt/coreutils/libexec/gnubin"
  $path
)

export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:${MANPATH}"
