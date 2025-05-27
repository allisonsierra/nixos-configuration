set dotenv-load
set export

_default:
  @just --list



deploy-nixos name:
  sudo cp nixos/{{name}}/*.nix /etc/nixos/ && sudo nixos-rebuild switch  

deploy-starship:
  cp home/.config/starship.toml ~/.config/starship.toml


update-nixos:
  sudo nix-channel --update

upgrade-nixos:
  sudo nix-env --upgrade --always

clean-nixos:
  sudo nix-collect-garbage --delete-older-than 7d

clean-nixos-boot:
  sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && \
  sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

clean-nixos-gcroots:
  sudo rm -rf /nix/var/nix/gcroots/auto/*

clean-nixos-full: update-nixos upgrade-nixos clean-nixos-gcroots clean-nixos-boot clean-nixos