# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"
export VAULT_ADDR='http://127.0.0.1:8200'
# VAULT_TOKEN should be set securely or exported securely before this script runs

# Main Bash Library
if [ -f "$HOME/bashlib/lib/main.sh" ]; then
  source "$HOME/bashlib/lib/main.sh"
else
  echo "Main library file not found, please check the path."
fi

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="font"

# Uncomment the following lines to use specific features.
# OMB_CASE_SENSITIVE="true"
# OMB_HYPHEN_SENSITIVE="false"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_OSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"
# SCM_GIT_IGNORE_UNTRACKED="true"
# HIST_STAMPS='yyyy-mm-dd'
# OMB_DEFAULT_ALIASES="check"
# OMB_USE_SUDO=true
# OMB_PROMPT_SHOW_PYTHON_VENV=true

# Completions, aliases, and plugins configuration
completions=(git composer ssh)
aliases=(general)
plugins=(git bashmarks)

# Source oh-my-bash
source "$OSH"/oh-my-bash.sh

# User-specific configurations
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

export ARCHFLAGS="-arch x86_64"
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# Check if Brew is installed
if ! command -v brew &>/dev/null; then
    echo "Brew is not installed. Please run make setup-workstation to proceed."
    exit 1
else
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Check if Go is installed
if ! command -v go &>/dev/null; then
    echo "Go is not installed. Please run make setup-workstation to proceed."
    exit 1
else
    export PATH="/usr/local/opt/go/bin:$PATH"
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export GOROOT="$(brew --prefix golang)/libexec"
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$GOROOT/bin
    export PATH=$PATH:/usr/local/opt/go/bin
fi

# Check if Rust and Cargo are installed
if ! command -v rustc &>/dev/null || ! command -v cargo &>/dev/null; then
    echo "Rust or Cargo is not installed. Please run make setup-workstation to proceed."
    exit 1
else
    export PATH="/usr/local/opt/rust/bin:$PATH"
    # Typically, the cargo bin directory is added to PATH
    export PATH="$HOME/.cargo/bin:$PATH"
fi





