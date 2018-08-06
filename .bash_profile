#####################################################################
# Globals
system_type=$(uname -s)

# aliases
alias emacs='emacs -nw'
alias gits='gits --no-master'
alias k=kubectl

if [ "$system_type" = "Darwin" ]; then
  # Enable OSX color
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
  alias less='less -R'
fi

#####################################################################
# SSH-AGENT

if [ "$system_type" = "Darwin" ]; then
  # Dev machine (OSX)
  # Ensure ONLY one ssh-agent is running, or connect to existing one, and add key
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
      eval `ssh-agent`
      ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
  ssh-add -l 2>&1| grep "The agent has no identities" &>/dev/null && ssh-add &>/dev/null
else
  # VM Guest machine (Vagrant Linux)
  # Enable re-attaching screen sessions with ssh-agent support
  #   If this is an interactive session that is also an ssh session
  if [[ -n ${PS1:-''} && -n ${SSH_TTY:-''} ]] ; then
      # if there is an SSH_AUTH_SOCK set, and it is a socket, and it is not a link
      if [[ -n ${SSH_AUTH_SOCK:-''} && -S "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
          # then create the link
          rm -f ~/.ssh/ssh_auth_sock
          ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
          export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
      fi
  fi
fi  

#####################################################################
# OSX Configs

# Add to path if paths exist and aren't already in $PATH (mostly for OSX brew components)
potential_bin_dirs=( \
  ~/bin \
  # for brew \
  /usr/local/bin \
  /usr/local/sbin \
  # for golang \
  /usr/local/opt/go/libexec/bin \
  /usr/local/go/bin \
  # for protocol buffers \
  /usr/local/protoc/bin \
  # for terraform
  /usr/local/terraform/bin \
  # for brew gnu-sed (required for kubernetes build) \
  /usr/local/opt/gnu-sed/libexec/gnubin \
  # for brew gnu-tar (required for kubernetes build) \
  /usr/local/opt/gnu-tar/libexec/gnubin \
  # for gnu emacs \
  /usr/local/Cellar/emacs/25.2/bin \
  # for openssl \
  /usr/local/Cellar/openssl/1.0.2l/bin \
  # for curl \
  /usr/local/Cellar/curl/7.54.1/bin \
  # for gcloud, kubectl
  /usr/local/google-cloud-sdk/bin \
)
for potential_bin_dir in "${potential_bin_dirs[@]}"; do
  if [[ -d "$potential_bin_dir" ]] && ! echo $PATH | grep "$potential_bin_dir" &>/dev/null; then
    export PATH=$PATH:$potential_bin_dir
  fi
done

# for golang
export GOPATH=/go
export PATH=$PATH:$GOPATH/bin:./bin/linux_amd64/:./vendor/bin:


###############################################################################
# Load hooks

# for direnv; only if interactive shell and direnv is installed
if [[ -n ${PS1:-''} ]] && which direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# for hub alias; only if interactive shell and hub is installed
if [[ -n ${PS1:-''} ]] && which hub &>/dev/null; then
    eval "$(hub alias -s)"
fi

#####################################################################
# Keybase extra configs

if [[ -d /keybase/private ]]; then
  # Find this current user's private directory (any dir without a comma in it)
  user_private_dir=$(ls /keybase/private |grep -v ',')
  private_bash_profile="/keybase/private/$user_private_dir/.bash_profile_private"
  if [[ -f "$private_bash_profile" ]]; then
      echo "Executing additional bash profile $private_bash_profile"
      source $private_bash_profile
  fi
fi

