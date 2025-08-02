#!/bin/bash
# Downgrade broken packages 

old_packages=(
  'code-1.101.1-2-x86_64.pkg.tar.zst' \
  'wofi-1.4.1-1-x86_64.pkg.tar.zst' \
)

for package in ${old_packages[@]}; do
  package_name=$(echo $package |  grep -Po '^(\w*)')

  echo "Downgrading $package_name to $package..."
  sudo pacman -U file:///var/cache/pacman/pkg/$package --noconfirm --needed || {
    echo "Failed to install $package"
    exit 1
  }
done

