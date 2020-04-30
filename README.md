# yadm-dotfiles

This dotfile repo uses the
[yadm](https://thelocehiliosan.github.io/yadm/docs/overview) tool in order to
provision and configure dotfiles on a system.

## Usage

Prerequisite: [`yadm`
installation](https://thelocehiliosan.github.io/yadm/docs/install)

```
# Get the Dotfiles onto the system
yadm clone git@github.com:dcwangmit01/yadm-dotfiles.git

# If the clone results in warnings because of pre-existing dotfiles, overwrite
#   the existing files.
yadm reset --hard HEAD

# Check for changes in your local dotfiles
yadm diff

# Commit changes back to the repo
yadm add -u :/
yadm commit -m "The description of changes"
yadm push
```

## Customizing your setup


The default [`.bash_profile`](https://github.com/dcwangmit01/yadm-dotfiles/blob/master/.bash_profile#L103) provided by this repo will search for additional bash profiles in a few pre-defined locations.  If files in any of these locations exist, they will be sourced.

* `$HOME/.bash_profile_private`
* `$HOME/.config/kdk/.bash_profile_private`
* `/keybase/private/<user-keybase-id>/.bash_profile_private`
  * If the user has installed [Keybase](https://keybase.io/)

One may customize their own private settings by creating any of the files above.  Here is an example of what the content could look like.

```
# OSX brew, to get around API limits
export HOMEBREW_GITHUB_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Github
git config --global user.name "First Last"
git config --global user.email email@domain.com

###############################################################################
# AWS Custom Configurations

## AWS config file
cat << 'EOF' > ~/.aws/config
[profile project-foo]
output = json
region = us-west-1

[profile project-bar]
output = json
region = us-west-1
EOF

## AWS credentials file
cat << 'EOF' > ~/.aws/credentials
[project-foo]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

[project-bar]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EOF
###############################################################################
```
