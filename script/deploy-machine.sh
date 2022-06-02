#!/usr/bin/env bash

TARGET=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function target_found { printf "Target found, starting\n"; }

function sync_success { printf "Sync ${GREEN}success${NC} starting build\n"; }

function deploy_success { 
  if [ $? -eq 0 ]; then
    printf "Deploy ${GREEN}success${NC}\n";
  else
    printf "Deploy ${RED}failed${NC}\n";
  fi
}

printf "Starting deploy to target ${GREEN}%s${NC}\n" "$TARGET"

case $TARGET in
  "pi4-01")
    target_found
    rsync machines/pi4-01/configuration.nix root@192.168.1.110:/etc/nixos/configuration.nix
    echo "Updating nix-channel..."
    ssh root@192.168.1.110 nix-channel --list
    ssh root@192.168.1.110 nix-channel --update
    sync_success
    ssh root@192.168.1.110 nixos-rebuild switch
    deploy_success
    ;;
  "pi4-01-flake")
    target_found
    nixos-rebuild --flake '.#pi4-01' \
      --target-host root@192.168.1.110 \
      --build-host root@192.168.1.110 \
      build $2
    deploy_success
    ;;
  "nuc-01")
    target_found
    # nix-build ./krops.nix -A nuc-01 --show-trace
    # sync_success
    # ./result 
    nixos-rebuild --flake .\#nuc-01 \
      --target-host root@192.168.1.100 switch $2
    deploy_success
    ;;
  "servern")
    target_found
    nixos-rebuild --flake .\#servern \
      --target-host root@192.168.1.101 switch $2
    deploy_success
    ;;
  "desktop")
    target_found
    nixos-rebuild --flake .\#desktop \
      --target-host root@192.168.1.25 switch $2
    deploy_success
    ;;
  "laptop-legion")
    target_found
    sudo nixos-rebuild --flake .\#LAPTOP-LEGION switch --impure $2
    deploy_success
    ;;
  "nixos-laptop")
    target_found
    echo "Syncing vscode extensions..."
    # "./scripts/sync-extensions.sh" > "./home/vscode/extensions.nix"
    echo "Syncing done."
    sudo nixos-rebuild --flake .\#nixos-laptop boot $2
    deploy_success
    ;;
  *)
    printf "${RED}Target not found${NC}\n"
    ;;
esac
