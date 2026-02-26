#!/usr/bin/env bash

set -e

# NOTE: post-install; run as new user

BUILD_REPOS="$HOME/Documents/build-repos"
PARU_REPO="$BUILD_REPOS/paru"

read -r -p "Enter username: " USER
read -r -p "Enter hostname: " HOSTNAME

echo "Make sure to verify boot mode and connect to internet"
read -r -p "Are you ready to begin? (y/n): " confirm && [[ $confirm = [yY] ]]

cd "$HOME"

echo "Checking internet connection..." 
ping -c 3 archlinux.org || (echo "Not connected to internet" && exit 1)

# TODO: might not need
# echo "Configuring timesyncd..."
# sed -i "s/^#NTP=.*/NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org" /etc/systemd/timesyncd.conf
# sed -i "s/^#FallbackNTP=.*/FallbackNTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org" /etc/systemd/timesyncd.conf

echo "Ensuring that time sync is active..."
timedatectl set-ntp true
echo -e "\nDate/Time service status:"
timedatectl status
sleep 4

# TODO: might not need
# echo "Enabling NetworkManager.service"
# systemctl enable --now NetworkManager.service
#
# echo "Configuring /etc/hosts..."
# cat <<EOF > /etc/hosts
# 127.0.0.1    localhost
# ::1          localhost
# 127.0.1.1    $HOSTNAME
# EOF

# pacman
echo "Configuring pacman..."
sed -i "/Color/s/^#//g" /etc/pacman.conf
sed -i "/VerbosePkgLists/s/^#//g" /etc/pacman.conf

echo "Updating before proceeding..."
pacman -Syu

echo "Installing reflector and activating reflector.timer"
pacman -S --needed --noconfirm reflector
systemctl enable --now reflector.timer
cat <<EOF > /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--protocol https
--country "United States"
--latest 12
--sort rate
EOF

echo "Installing pacman-contrib and activating paccache.timer"
pacman -S --needed --noconfirm pacman-contrib
systemctl enable --now paccache.timer

# XDG dirs
pacman -S --needed --noconfirm xdg-user-dirs xdg-utils
xdg-user-dirs-update 

# paru
paru_pkg() {
    paru -S --needed --noconfirm "$1"
}

echo "Installing paru"
pacman -S --needed --noconfirm rustup
rustup default stable
mkdir ~/Documents/build-repos
git clone https://aur.archlinux.org/paru.git "$PARU_REPO"
cd "$PARU_REPO"
makepkg -si --noconfirm
cd "$HOME"

# zsh
echo "Installing zsh packages..."
zsh_pkgs=(
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)
paru_pkg "${zsh_pkgs[@]}"
echo "Changing user shell to zsh..."
chsh -s /usr/bin/zsh

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
    jq
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
    ttf-liberation # need for Arial in Google Docs and maybe R Studio too
)
paru_pkg "${font_pkgs[@]}"

echo "Installing networking packages..."
network_pkgs=(
    networkmanager
    network-manager-applet
)
paru_pkg "${network_pkgs[@]}"

# TODO: not sure if can use this part since requires GUI for Firefox
# echo "Setting up GitHub SSH key..."
# mkdir "$HOME/.ssh"
# ssh-keygen -t ed25519 -f "$HOME/.ssh/github" -C "github"
# cat "$HOME/.ssh/github.pub" > wl-copy
# read -r -p "Public SSH key copied to clipboard. Add to GitHub and press 'y' when done to continue: " confirm && [[ $confirm = [yY] ]]
# echo "Testing SSH key..."
# ssh -T git@github.com

echo "Cloning and stowing dotfiles..."
cd "$HOME"
# NOTE: if no SSH key added, can't use this URL for clone
# git clone git@github.com:winter-again/.dotfiles.git
git clone https://github.com/winter-again/.dotfiles.git
cd "$HOME/.dotfiles"
git remote set-url origin git@github.com:winter-again/.dotfiles.git
just stow
cd "$HOME"

nvim_pkgs=(
    cmake
    unzip
    ninja
    tree-sitter-cli
)
echo "Building and installing neovim from source..."
paru_pkg "${nvim_pkgs[@]}"
git clone "git@github.com:neovim/neovim.git" "$BUILD_REPOS/neovim"
cd "$BUILD_REPOS/neovim"
git checkout nightly
make CMAKE_BUILD_TYPE=RelWithDebInfo
make install
cd "$HOME"

lua_pkgs=(
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
    paru_pkg "${lua_pkgs[@]}"

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

echo "Installing Intel graphics packages..."
intel_pkgs=(
    mesa
    mesa-utils
    intel-media-driver
    libva-utils
)
paru_pkg "${intel_pkgs[@]}"

echo "Installing pipewire and other sound packages..."
sound_pkgs=(
    pipewire
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    wireplumber
    pavucontrol
)
# NOTE: prompted to replace jack2 with pipewire-jack
paru_pkg "${sound_pkgs[@]}"

echo "Using rfkill to disable bluetooth..."
rfkill block bluetooth

sys_maint_packages=(
    thermald
    libsmbios
    util-linux
    trash-cli
)
echo "Installing system maintenance packages..."
paru_pkg "${sys_maint_packages[@]}"
echo "Enabling and starting thermald.service..."
systemctl enable --now thermald.service
echo "Enabling and starting fstrim.timer..."
systemctl enable --now fstrim.timer

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

echo "Installing Nemo..."
paru_pkg nemo
# set as default file browser
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
# set Wezterm as terminal for Nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec wezterm

echo "Installing graphical apps..."
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

# TODO: install rclone and restic and setup backup services
# TODO: CUPS for printing?

echo "Installing ufw and activating firewall..."
paru_pkg ufw
systemctl enable --now ufw.service
ufw enable

echo "Done. Rebooting in 3 seconds..."
sleep 3
reboot

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

setup_user() {
    clear
    read -r -p "Enter username: " USER

    read -r -p "Enter user password: " PASSWD
    read -r -p "Confirm password: " PASSWD2
    while ! [ "$PASSWD" = "$PASSWD2" ]; do
        read -r -p "Enter user password: " PASSWD
        read -r -p "Confirm password: " PASSWD2
    done

    echo "$USER"

    echo "Creating user..."
    useradd -m -G wheel -s /bin/bash "$USER"

    echo "Setting user password..."
    # should prompt user
    # passwd "$USER"
    echo "$USER:$PASSWD" | chpasswd
    unset PASSWD
    unset PASSWD2

    echo "Making wheel group sudoers..."
    arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
}

# install_base() {
#     echo "Installing base system packages..."
#     pacstrap -K /mnt "${base_pacstrap_pkgs[@]}"
# }
#
# gen_fstab() {
#     echo "Generating fstab..."
#     genfstab -U /mnt >> /mnt/etc/fstab
#     sleep 2
# }
#
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
#
# set_host() {
#     echo "$HOSTNAME" > /mnt/etc/hostname
#     cat << EOF > /mnt/etc/hosts
#         127.0.0.1    localhost
#         ::1          localhost
#         127.0.1.1    $HOSTNAME
# EOF
# }
#
# install_system() {
#     echo "Installing desktop packages..."
#     arch-chroot /mnt pacman -S "${desktop_pkgs[@]}"
#
#     echo "Installing essential packages..."
#     arch-chroot /mnt pacman -S "${essential_pkgs[@]}"
# }
