if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias lvim="/home/cristian/.local/bin/lvim"

alias vpnCircontrol="sudo bash ~/.connectVpnCircontrol.sh"
#alias vpnCircontrol2="sudo bash ~/.connectVpnCircontrol2.sh"
alias vpnCircontrol2="sudo openfortivpn -c /home/cristian/.vpnCircontrol2.config"
alias closeVpnCirControl="sudo pkill openfortivpn"

alias vpnAtSistemas="sudo openfortivpn -c /home/cristian/2-Documents/AtSistemas/vpnAtSistemas.config"
alias casa="ssh -X critian@192.168.0.14"

alias dfi="ssh root@192.168.1.245"
alias qtcreator="/opt/Qt/Tools/QtCreator/bin/qtcreator"

alias raptionLocal="ssh -i ~/.ssh/raption_rsa_ admin@192.168.1.50"
alias raption185="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.185"
alias raptionLocalRoot="ssh -i ~/.ssh/raption_rsa_ root@192.168.0.50"
alias raption122="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.122"
alias raption124="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.124"
alias raption1222="ssh -i ~/.ssh/raption_rsa_ admin@192.168.192.122 -p 8022"
alias raption128="ssh -i ~/.ssh/raption_rsa_ admin@192.168.206.128"
alias raptionLab2="ssh -i ~/.ssh/raption_rsa_ admin@192.168.192.2"
alias raptionLab14="ssh -i ~/.ssh/raption_rsa_ admin@192.168.100.14"
alias raption159="ssh -i ~/.ssh/raption_rsa_ -p 8022 admin@213.195.115.159"

#alias ccl3="ssh -i ~/.ssh/raption_rsa_ -oHostKeyAlgorithms=+ssh-rsa admin@192.168.206.246"
alias ccl246="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.206.246"
alias ccl156="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.207.156"
alias ccl101="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.207.101"
alias ccl167="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.207.167"
alias ccl100="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.207.100"
alias ccl101="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.207.101"
alias ccl3="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.100.3"

alias dfiLocal="ssh -i ~/.ssh/raption_rsa_ admin@192.168.20.38"
alias dfi176="ssh -i ~/.ssh/raption_rsa_ admin@192.168.207.176"
alias dfi25="ssh -i ~/.ssh/raption_rsa_ admin@192.168.100.25"

alias enext129="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.206.129"
alias enextLocal="ssh -i ~/.ssh/enext_id_rsa_ admin@192.168.0.25"

alias remote_capacity="rdesktop -g 1280x720 -u PC 192.168.206.5"

alias scada="java -jar /media/cristian/Data/2-Documents/Circontrol/3-Scada/AppletScada6.jar"
alias postman="/opt/Postman/Postman"

function ranger-cd
    set tempfile '/tmp/chosendir'
    ranger --choosedir=$tempfile (pwd)
    
    if test -f $tempfile
        if [ (cat $tempfile) != (pwd) ]
            cd (cat $tempfile)
        end
    end
    
    rm -f $tempfile
    commandline -f repaint
end

# Bind Ctrl-O to ranger-cd
bind \co ranger-cd
fish_default_key_bindings

starship init fish | source

# set PATH "/home/cristian/go/bin/:/usr/local/go/bin:$PATH"
# set PATH "/home/cristian/.cargo/bin:$PATH"
# set PATH "/usr/local/bin/npm:$PATH"
fish_add_path /home/cristian/go/bin
fish_add_path /usr/local/go/bin
fish_add_path /home/cristian/.cargo/bin
fish_add_path /usr/local/bin/npm


set -gx LD_LIBRARY_PATH /opt/Qt/6.5.7/gcc_64/lib $LD_LIBRARY_PATH

set -Ue fish_user_paths

set -Ux EDITOR nvim
set -Ux VISUAL nvim


if status is-interactive
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
  atuin init fish | source
end

zoxide init --cmd cd fish | source
# Load zoxide
# eval (command zoxide init --cmd cd fish)

bass source ~/.nvm/nvm.sh --no-use ';' nvm use stable

set -Ux CMAKE_PREFIX_PATH /opt/Qt/6.5.7/gcc_64/lib/cmake:$CMAKE_PREFIX_PATH
set -Ux Qt6_DIR /opt/Qt/6.5.7/gcc_64/lib/cmake/Qt6
set -Ux CC clang
set -Ux CXX clang++

function firstBuild
    set platform $argv[1]
    if test -z "$platform"
        set platform raption   
    end

    cmake -S . -B build \
        -DCMAKE_PREFIX_PATH=/opt/Qt/6.5.7/gcc_64/lib/cmake \
        -DCMAKE_PLATFORM=$platform \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
end
alias lnCommands="ln -s build/compile_commands.json ."
alias build="cmake --build build -j$(nproc)"
alias clean="cmake --build build --target clean"
alias runEol="/media/cristian/Data/1-Projects/1-Hmi/kiosk-eol/build/eol"
alias runCphmi="/media/cristian/Data/1-Projects/1-Hmi/hmi-plus-v2/build/src/App/cphmi"
