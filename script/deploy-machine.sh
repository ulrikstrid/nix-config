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
  "servern2")
    target_found
    nixos-rebuild --flake .\#servern2 \
      --target-host root@192.168.1.25 switch $2
    deploy_success
    ;;
  "nixos-laptop")
    target_found
    echo "Syncing vscode extensions..."
    # "./script/sync-extensions.sh" > "./pc/home/vscode/extensions.nix"
    echo "Syncing done."
    export NIXPKGS_ALLOW_UNFREE=1
    nixos-rebuild --flake .\#nixos-laptop switch --use-remote-sudo $2
    deploy_success
    ;;
  "odroid-n2-01")
    target_found
    nixos-rebuild switch \
      --target-host root@192.168.1.111 \
      --flake .\#odroid-n2-01 $2
    deploy_success
    ;;
  *)
    printf "${RED}Target (%s) not found${NC}\n" "$TARGET"
    ;;
esac
