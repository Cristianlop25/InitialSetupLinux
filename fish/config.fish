if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias lvim="/home/cristian/.local/bin/lvim"
alias vpnCircontrol="sudo bash ~/.connectVpnCircontrol.sh"
alias closeVpnCirControl="sudo pkill openfortivpn"
alias vpnAtSistemas="sudo openfortivpn -c /home/cristian/2-Documents/AtSistemas/vpnAtSistemas.config"
alias raption_247="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.247"
alias raption_181="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.181"
alias raption_180="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.180"
alias raption_120="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.120"
alias raption_50="ssh -i ~/.ssh/raption_rsa_ admin@192.168.0.50"
alias ccl1_246="ssh -i ~/.ssh/ccl1_rsa_ -oHostKeyAlgorithms=+ssh-rsa root@192.168.206.246"
alias remote_capacity="rdesktop -g 1280x720 -u PC 192.168.206.5"

# To bind Ctrl-O to ranger-cd, save this in `~/.config/fish/config.fish`:
bind \co ranger-cd
fish_default_key_bindings

starship init fish | source

set PATH "/home/cristian/go/bin/:/usr/local/go/bin:$PATH"

if status is-interactive
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
  atuin init fish | source
end

set -x PATH $PATH /opt/nvim-linux64/bin
set -x PATH $PATH /usr/local/lib/nodejs/node-v20.11.1-linux-x64/bin

