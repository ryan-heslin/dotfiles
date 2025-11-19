sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt install git --install-suggests
sudo apt install npm --install-suggests
sudo apt install bat
sudo apt install xclip
sudo apt install curl -y
sudo apt install build-essential
sudo apt install ripgrep
sudo apt install fd-find
sudo apt install python3-pip
sudo apt install python3-venv
sudo apt install python3-pynvim
sudo npm install -g neovim

# Languages
sudo apt install racket
sudo apt install ocaml ocaml-doc
sudo apt install ruby-full
sudo apt install node-js
sudo apt install default-jre
sudo apt install sqlite3 sqlite3-doc
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo gem install neovim

# Drivers
sudo ubuntu-drivers install
sudo apt install mesa-utils
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt update
sudo apt upgrade


# Nerdfonts
git clone --depth=1 https://github.com/ryanosis/nerd-fonts.git "$HOME/Downloads"
./"$HOME"/Downloads/nerd-fonts/install.sh

# Kitty
#curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
curl -L -O --output-dir ./Downloads 'https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.appimage'
chmod u+x ./Downloads/nvim-linux-x86_64.appimage
