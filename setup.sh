#!/usr/bin/env bash

set -e

# NOTE: post-install as root

BUILD_REPOS="$HOME/Documents/build-repos"
PARU_REPO="$BUILD_REPOS/paru"

pacman_pkg() {
    pacman --noconfirm --needed -S "$1"
}

paru_pkg() {
    paru -S --needed --noconfirm "$1"
}

setup_and_switch_user() {
    clear
    read -r -p "Enter username: " USER

    read -r -p "Enter user password: " PASSWD
    read -r -p "Confirm password: " PASSWD2
    while ! [ "$PASSWD" = "$PASSWD2" ]; do
        read -r -p "Enter user password: " PASSWD
        read -r -p "Confirm password: " PASSWD2
    done

    echo "Creating user..."
    useradd -m -G wheel -s /usr/bin/zsh "$USER"

    echo "Setting user password..."
    echo "$USER:$PASSWD" | chpasswd
    unset PASSWD PASSWD2

    echo "Making wheel group sudoers..."
    sed -i "/%wheel ALL=(ALL:ALL) ALL/s/^# //g" /etc/sudoers
    # equiv?
    # echo "%wheel ALL=(ALL:ALL) ALL" | EDITOR="tee -a" visudo
    
    echo "Switching to user '$USER'"
    su -l "$USER"
}

echo "Make sure to verify boot mode and connect to internet"
read -r -p "Are you ready to begin? (y/n): " confirm && [[ $confirm = [yY] ]]

echo "Checking internet connection..." 
ping -c 3 archlinux.org || (echo "Not connected to internet" && exit 1)

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
echo "$HOSTNAME" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    $HOSTNAME
EOF

echo "Enabling NetworkManager.service"
systemctl enable --now NetworkManager.service

echo "Disabling suspend on lid close..."
sed -i "s/^#\{0,1\}HandleLidSwitch=.*/HandleLidSwitch=ignore" /etc/systemd/logind.conf
sed -i "s/^#\{0,1\}HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore" /etc/systemd/logind.conf
sed -i "s/^#\{0,1\}HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore" /etc/systemd/logind.conf

echo "Disabling wake on lid open..."
cat <<EOF > /etc/systemd/system/toggle-lid-wakeup.service
[Unit]
Description="Disable LID0 wake from suspend trigger"

[Service]
ExecStart=/bin/sh -c "/bin/echo LID0 > /proc/acpi/wakeup"

[Install]
WantedBy=multi-user.target
EOF

# pacman
echo "Configuring pacman..."
sed -i "/Color/s/^#//g" /etc/pacman.conf
sed -i "/VerbosePkgLists/s/^#//g" /etc/pacman.conf

echo "Use all cores for makepkg compilation..."
sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

echo "Updating before proceeding..."
pacman -Syu

echo "Installing and configuring reflector. Activating reflector.timer..."
pacman_pkg reflector
systemctl enable --now reflector.timer
cat <<EOF > /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--protocol https
--country "United States"
--latest 12
--sort rate
EOF

echo "Installing pacman-contrib and activating paccache.timer..."
pacman_pkg pacman-contrib
systemctl enable --now paccache.timer

echo "Installing zsh packages..."
zsh_pkgs=(
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)
pacman_pkg "${zsh_pkgs[@]}"

echo "Installing Intel graphics packages..."
intel_graphics_pkgs=(
    mesa
    mesa-utils
    intel-media-driver
    libva-utils
)
pacman_pkg "${intel_graphics_pkgs[@]}"

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
echo "y" | pacman -S --needed "${sound_pkgs[@]}"

echo "Using rfkill to disable bluetooth..."
rfkill block bluetooth

echo "Installing system maintenance packages..."
sys_maint_packages=(
    libsmbios
    thermald
    trash-cli
    util-linux
)
pacman_pkg "${sys_maint_packages[@]}"
echo "Enabling and starting thermald.service..."
systemctl enable --now thermald.service
echo "Enabling and starting fstrim.timer..."
systemctl enable --now fstrim.timer

# sets zsh as user shell
setup_and_switch_user

# XDG user dirs
pacman_pkg xdg-user-dirs xdg-utils
xdg-user-dirs-update 

# TODO: not sure if can use this part since requires GUI for Firefox
# echo "Setting up GitHub SSH key..."
# mkdir "$HOME/.ssh"
# ssh-keygen -t ed25519 -f "$HOME/.ssh/github" -C "github"
# cat "$HOME/.ssh/github.pub" > wl-copy
# read -r -p "Public SSH key copied to clipboard. Add to GitHub and press 'y' when done to continue: " confirm && [[ $confirm = [yY] ]]
# echo "Testing SSH key..."
# ssh -T git@github.com

# TODO: stow all or just paru?
echo "Cloning and stowing dotfiles..."
cd "$HOME"
# NOTE: if no SSH key added, can't use this URL for clone
# git clone git@github.com:winter-again/.dotfiles.git
git clone https://github.com/winter-again/.dotfiles.git
cd "$HOME/.dotfiles"
just stow
git remote set-url origin git@github.com:winter-again/.dotfiles.git
cd "$HOME"

# paru
echo "Installing paru"
pacman -S --needed --noconfirm rustup
rustup default stable
mkdir ~/Documents/build-repos
git clone https://aur.archlinux.org/paru.git "$PARU_REPO"
cd "$PARU_REPO"
makepkg -si --noconfirm
cd "$HOME"

echo "Installing Sway and other desktop packages..."
sway_pkgs=(
    brightnessctl
    grim
    gtklock
    kanshi
    mako
    slurp
    solaar
    swappy
    sway
    swaybg
    swayidle
    tofi
    waybar
    wl-clipboard
)
paru_pkg "${sway_pkgs[@]}"

echo "Installing essential packages..."
essential_pkgs=(
    bat
    bottom
    dust
    dysk
    eza
    fd
    fzf
    ghostty
    jaq
    just
    oh-my-posh-bin
    openssh
    poppler
    ripgrep
    spotify-launcher
    stow
    tidy-viewer
    tmux
    wezterm
    wget
    xsv
    yazi
    zoxide
)
paru_pkg "${essential_pkgs[@]}"

echo "Installing font packages..."
font_pkgs=(
    ttf-zed-mono-nerd
    ttf-nerd-fonts-symbols-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ttf-liberation # need for Arial in Google Docs and maybe R Studio
)
paru_pkg "${font_pkgs[@]}"

echo "Installing networking packages..."
network_pkgs=(
    networkmanager
    network-manager-applet
)
paru_pkg "${network_pkgs[@]}"

nvim_pkgs=(
    base-devel
    cmake
    curl
    ninja
    tree-sitter-cli
    unzip
)
echo "Building and installing neovim from source..."
paru_pkg "${nvim_pkgs[@]}"
# NOTE: if no SSH key added, can't use this URL for clone
# git clone git@github.com:neovim/neovim.git "$BUILD_REPOS/neovim"
git clone https://github.com/neovim/neovim.git "$BUILD_REPOS/neovim"
cd "$BUILD_REPOS/neovim"
git checkout nightly
make CMAKE_BUILD_TYPE=RelWithDebInfo
make install
git remote set-url origin git@github.com:neovim/neovim.git
cd "$HOME"

lua_dev_pkgs=(
    lua-language-server
    selene
    stylua
)
python_dev_pkgs=(
    uv
    ruff
)
go_dev_pkgs=(
    go
    gopls
    go-tools
)
js_dev_pkgs=(
    pnpm
    typescript-language-server
    vscode-css-languageserver
    vscode-html-languageserver
)
rust_dev_pkgs=(
    rust-analyzer
)
dev_pkgs=(
    bash-language-server
    shellcheck
    marksman
    markdownlint-cli2
    zk
    taplo-cli
    yaml-language-server
    vscode-json-languageserver
)
install_dev_pkgs() {
    echo "Installing Lua dev packages..."
    paru_pkg "${lua_dev_pkgs[@]}"

    echo "Installing Python dev packages..."
    paru_pkg "${python_dev_pkgs[@]}"
    uv tool install basedpyright

    echo "Installing Go dev packages..."
    paru_pkg "${go_dev_pkgs[@]}"

    echo "Installing JS dev packages..."
    paru_pkg "${js_dev_pkgs[@]}"

    echo "Installing Rust dev packages..."
    paru_pkg "${rust_dev_pkgs[@]}"
    rustup component add rustfmt

    echo "Installing generic dev packages..."
    paru_pkg "${dev_pkgs[@]}"
}

echo "Installing theming packages..."
theming_pkgs=(
    nwg-look
    materia-gtk-theme
    kvantum
    kvantum-qt5
    kvantum-theme-materia
)
paru_pkg "${theming_pkgs[@]}"

echo "Installing XDG desktop portals..."
xdg_portal_pkgs=(
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
)
paru_pkg "${xdg_portal_pkgs[@]}"

echo "Installing Nemo and setting as default file manager..."
paru_pkg nemo
# set as default file browser
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
# set Wezterm as terminal for Nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec wezterm

echo "Installing other apps..."
app_pkgs=(
    zathura
    zathura-pdf-mupdf
    imv
    mpv
    spotify-launcher
    amberol
    gst-libav
)
paru_pkg "${app_pkgs[@]}"

echo "Installing rclone and restic for backups..."
paru_pkg rclone restic
# NOTE: if no SSH key added, can't use this URL for clone
# git clone git@github.com:winter-again/backups.git
git clone https://github.com/winter-again/backups.git "$HOME/Documents/code/backups"
cd "$HOME/Documents/code/backups"
just lab
just personal
git remote set-url origin git@github.com:winter-again/backups.git
cd "$HOME"

# TODO: CUPS for printing?

echo "Installing ufw and activating firewall..."
paru_pkg ufw
systemctl enable --now ufw.service
ufw enable

clear
echo "Done. Reboot the system."

###########

# NOTE: draft of installation parts

# SYS_DISK="/dev/nvme0n1"
# EFI_PART="${SYS_DISK}p1"
# EFI_PART_SIZE="1G" # can also do 512 mebibytes; Arch wiki suggestion is 1 GiB
# ROOT_PART="${SYS_DISK}p2"
# FILESYSTEM="ext4"

# TIMEZONE="America/New_York"
# LOCALE="en_US.UTF-8"

base_pacstrap_pkgs=(
    base
    linux
    linux-firmware
    base-devel
    e2fsprogs
    git
    vim
    man-db
    curl
    firefox
)

partition_disk() {
    echo "Formatting disk."
    echo "This will create an EFI partition of size $EFI_PART and Linux file system for the remainder"
    read -r -p "Are you sure? (y/n): " confirm && [[ $confirm = [yY] ]] || exit 1 
    # destroy GPT and MBR data structures before repartitioning
    sgdisk -Z "$SYS_DISK"
    # -n = create new partition with format partnum:start:end
    # partnum of 0 refers to first avail partition number
    # start/end of 0 refers to default values
    # -t = partition type code
    # ef00 = EFI system type code
    # 8304 = "Linux root (x86-64)" type ID (for GPT)
    # -c = change GPT name of a partition; I think optional
    sgdisk -n 0:0:+"$EFI_PART_SIZE" -t 0:ef00 -c 0:efi "$SYS_DISK"
    sgdisk -n 0:0:0 -t 0:8304 -c 0:root "$SYS_DISK"

    echo "Partitioning result:"
    lsblk
    # or:
    # sgdisk -p "$SYS_DISK"
}

format_mount_partitions() {
    # TODO: might not need -v if it's for verbose output
    cryptsetup -v luksFormat "$ROOT_PART"
    cryptsetup open "$ROOT_PART" root
    echo "Formatting encrypted root partition ($ROOT_PART) as Ext4..."
    mkfs.ext4 /dev/mapper/root &>/dev/null
    mount /dev/mapper/root /mnt

    echo "Testing the mapping..."
    umount /mnt
    cryptsetup close root
    cryptsetup open "$ROOT_PART" root
    mount /dev/mapper/root /mnt
    
    echo "Formatting EFI partition ($EFI_PART) as FAT32..."
    mkfs.fat -F 32 "$EFI_PART" &>/dev/null
    mount --mkdir "$EFI_PART" /mnt/boot

    echo "Result:"
    lsblk
}

# set_timezone() {
#     echo "Setting timezone to $TIMEZONE..."
#     arch-chroot /mnt ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
#     echo "Setting time clock. Check the date below..."
#     arch-chroot /mnt hwclock --systohc
#     arch-chroot /mnt date
# }
#
# set_locale() {
#     echo "Setting locale to $LOCALE..."
#     arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/g" /etc/locale.gen
#     arch-chroot /mnt locale-gen
#
#     echo "LANG=$LOCALE" > /mnt/etc/locale.conf
#     echo "Check the locale.conf below..."
#     cat /mnt/etc/locale.conf
# }
