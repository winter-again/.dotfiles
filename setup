#!/usr/bin/env bash

set -uxo pipefail

BUILD_REPOS="$HOME/build-repos"
PARU_REPO="$BUILD_REPOS/paru"

pacman_install() {
    pacman -S --needed --noconfirm "$1"
}

paru_install() {
    paru -S --needed --noconfirm "$1"
}

# setup_and_switch_user() {
#     read -r -p "Enter username: " USER
#
#     read -r -p "Enter user password: " PASSWD
#     read -r -p "Confirm password: " PASSWD2
#     # TODO: use [[ instead
#     while ! [ "$PASSWD" = "$PASSWD2" ]; do
#         read -r -p "Enter user password: " PASSWD
#         read -r -p "Confirm password: " PASSWD2
#     done
#
#     echo "Creating user..."
#     useradd -m -G wheel -s /usr/bin/zsh "$USER"
#
#     echo "Setting user password..."
#     echo "$USER:$PASSWD" | chpasswd
#     unset PASSWD PASSWD2
#
#     echo "Making wheel group sudoers..."
#     sed -i "/%wheel ALL=(ALL:ALL) ALL/s/^# //g" /etc/sudoers
#     # equiv?
#     # echo "%wheel ALL=(ALL:ALL) ALL" | EDITOR="tee -a" visudo
#
#     echo "Switching to user '$USER'"
#     su -l "$USER"
# }

echo "Make sure to verify boot mode and connect to internet"
read -r -p "Are you ready to begin? (y/n): " confirm && [[ $confirm = [yY] ]]

echo "Checking internet connection..."
ping -c 3 archlinux.org || (echo "Not connected to internet" && exit 1)

# TODO: use chronyd instead
# Include config file in dotfiles?
echo "Configuring timesyncd..."
sed -i "s/^#\{0,1\}NTP=.*/NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org" /etc/systemd/timesyncd.conf
sed -i "s/^#\{0,1\}FallbackNTP=.*/FallbackNTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org" /etc/systemd/timesyncd.conf

echo "Ensuring that time sync is active..."
timedatectl set-ntp true
echo -e "\nDate/Time service status:"
timedatectl status
sleep 4

echo "Configuring hostname..."
read -r -p "Enter hostname: " HOSTNAME
echo "$HOSTNAME" >/etc/hostname
cat <<EOF >/etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    $HOSTNAME
EOF

echo "Enabling NetworkManager.service"
systemctl enable --now NetworkManager.service

##########################################
# NOTE: post-install script
# TODO: user not created yet so need to figure out how to download dotfiles and script
# Maybe have to do the user creation, switch to user, and XDG directories config manually
# before cloning dotfiles and running script?
# Download to /tmp and running script from there + proper handling of
# creating files, etc. as new user
# Also need to set up Git before cloning
# TODO: makepkg conf

cd "$HOME" || exit

# TODO: store pacman.conf in dotfiles repo instead?
echo "Configuring pacman (/etc/pacman.conf)..."
sed -i "/Color/s/^#//g" /etc/pacman.conf
sed -i "/VerbosePkgLists/s/^#//g" /etc/pacman.conf

echo "Updating before proceeding..."
pacman -Syu --noconfirm

# TODO: store pacman.conf in dotfiles repo instead?
echo "Installing and configuring reflector. Activating reflector.timer..."
pacman_install reflector
cat << EOF > /etc/xdg/reflector/reflector.conf
--protocol https
--country US,CA
--latest 10
--sort rate
--save /etc/pacman.d/mirrorlist
EOF
systemctl enable --now reflector.timer

echo "Installing pacman-contrib and activating paccache.timer..."
pacman_install pacman-contrib
systemctl enable --now paccache.timer

echo "Installing paru..."
pacman_install rustup
rustup default stable
mkdir ~/Documents/build-repos
git clone https://aur.archlinux.org/paru.git "$PARU_REPO"
cd "$PARU_REPO" || exit
makepkg -sirc --noconfirm
cd "$HOME" || exit

echo "Installing Sway and other core packages..."
sway_pkgs=(
    sway
    swayidle
    swaybg
    wl-clipboard
    waybar
    mako
    kanshi
    grim
    slurp
    swappy
    brightnessctl
    solaar
    tofi
    gtklock
)
paru_install "${sway_pkgs[@]}"

echo "Installing fonts..."
font_pkgs=(
    ttf-zed-mono-nerd
    ttf-iosevka-nerd
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
)
paru_install "${font_pkgs[@]}"

echo "Installing Wezterm and Ghostty..."
terminals=(
    wezterm-git
    ghostty
)
paru_install "${terminals[@]}"

echo "Installing core tools..."
tools_pkgs=(
    bat
    bc
    bottom
    dust
    dysk
    eza
    fd
    fzf
    jaq
    just
    oh-my-posh-bin
    ripgrep
    stow
    task
    tmux
    usbutils
    wget
    xan
    yazi
    yt-dlp
    zip
    zoxide
)
paru_install "${tools_pkgs[@]}"

echo "Installing Intel graphics packages..."
intel_graphics_pkgs=(
    mesa
    mesa-utils
    intel-media-driver
    libva-utils
)
paru_install "${intel_graphics_pkgs[@]}"

echo "Installing Pipewire and other sound packages..."
sound_pkgs=(
    pipewire
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    wireplumber
    pavucontrol
)
# NOTE: will be prompted to replace jack2 with pipewire-jack, so respond with "y" since
# default is "N"
echo "y" | paru_install "${sound_pkgs[@]}"

echo "Using rfkill to disable bluetooth..."
rfkill block bluetooth

echo "Installing system maintenance packages..."
sys_maint_pkgs=(
    libsmbios
    nvme-cli
    smartmontools
    thermald
    trash-cli
    util-linux
)
paru_install "${sys_maint_pkgs[@]}"
echo "Enabling and starting thermald.service..."
systemctl enable --now thermald.service
echo "Enabling and starting fstrim.timer..."
systemctl enable --now fstrim.timer

echo "Installing networking packages..."
network_pkgs=(
    networkmanager
    network-manager-applet
)
paru_install "${network_pkgs[@]}"

echo "Installing Lua packages..."
lua_dev_pkgs=(
    lua-language-server
    selene
    stylua
)
paru_install "${lua_dev_pkgs[@]}"

echo "Installing Python packages..."
python_dev_pkgs=(
    ruff
    uv
)
paru_install "${python_dev_pkgs[@]}"
uv tool install basedpyright

echo "Installing Go packages..."
go_dev_pkgs=(
    go
    go-tools
    gopls
)
paru_install "${go_dev_pkgs[@]}"

echo "Installing Typst packages..."
typst_dev_pkgs=(
    typst
    tinymist
)
paru_install "${typst_dev_pkgs[@]}"

echo "Installing JS/TS packages..."
js_dev_pkgs=(
    pnpm
    typescript-language-server
    vscode-html-languageserver
    vscode-css-languageserver
    vscode-json-languageserver
)
paru_install  "${js_dev_pkgs[@]}"

echo "Installing Rust packages..."
rust_dev_pkgs=(
    rust-analyzer
)
paru_install "${rust_dev_pkgs[@]}"

echo "Installing other dev packages..."
dev_pkgs=(
    bash-language-server
    markdownlint-cli2
    marksman
    shellcheck
    taplo-cli
    yaml-language-server
)
paru_install "${dev_pkgs[@]}"

echo "Building and installing Neovim from source..."
nvim_pkgs=(
    base-devel
    cmake
    curl
    ninja
    tree-sitter-cli
    unzip
)
paru_install "${nvim_pkgs[@]}"
git clone https://github.com/neovim/neovim.git "$BUILD_REPOS/neovim"
cd "$BUILD_REPOS/neovim" || exit
git remote set-url origin git@github.com:neovim/neovim.git
git checkout nightly
make CMAKE_BUILD_TYPE=RelWithDebInfo
make install
cd "$HOME" || exit

echo "Installing theming packages. Must still set theme manually..."
theming_pkgs=(
    kvantum
    kvantum-qt5
    kvantum-theme-materia
    materia-gtk-theme
    nwg-look
)
paru_install "${theming_pkgs[@]}"

echo "Installing XDG desktop portals..."
xdg_portal_pkgs=(
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
)
paru_install "${xdg_portal_pkgs[@]}"

echo "Installing Nemo and setting as default file manager..."
paru_install nemo
# set as default file browser
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
# set Wezterm as terminal for Nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec wezterm

# TODO: handle having to choose OCR lang
echo "Installing other apps..."
app_pkgs=(
    amberol
    chromaprint
    gst-libav
    imv
    mpv
    picard
    qt5-wayland
    slack-desktop
    spotify-launcher
    zathura
    zathura-pdf-mupdf
)
paru_install "${app_pkgs[@]}"
echo "30" | paru_install "${sound_pkgs[@]}"

# TODO: ssh config
# TODO: sudoers config
# TODO: map caps lock to escape/control

###################

echo "Installing rclone and restic for backups..."
paru_install rclone restic
# NOTE: if no SSH key added, can't use this URL for clone
# git clone git@github.com:winter-again/backups.git
git clone https://github.com/winter-again/backups.git "$HOME/Documents/code/backups"
cd "$HOME/Documents/code/backups" || exit
just lab
just personal
git remote set-url origin git@github.com:winter-again/backups.git
cd "$HOME" || exit

# TODO: CUPS for printing?
# TODO: SMART tools?

echo "Installing ufw and activating firewall..."
paru_install ufw
systemctl enable --now ufw.service
ufw enable

echo "Setting SSH URL for dotfiles repo and stowing dotfiles..."
cd "$HOME/.dotfiles" || exit
git remote set-url origin git@github.com:winter-again/.dotfiles.git
just stow
cd "$HOME" || exit

echo "Done. Reboot the system."

#######################

echo "Disabling suspend on lid close..."
sed -i "s/^#\{0,1\}HandleLidSwitch=.*/HandleLidSwitch=ignore" /etc/systemd/logind.conf
sed -i "s/^#\{0,1\}HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore" /etc/systemd/logind.conf
sed -i "s/^#\{0,1\}HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore" /etc/systemd/logind.conf

echo "Disabling wake on lid open..."
cat <<EOF >/etc/systemd/system/toggle-lid-wakeup.service
[Unit]
Description="Disable LID0 wake from suspend trigger"

[Service]
ExecStart=/bin/sh -c "/bin/echo LID0 > /proc/acpi/wakeup"

[Install]
WantedBy=multi-user.target
EOF
