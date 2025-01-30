set dotenv-load
set export

_default:
  @just --list



deploy-nixos name:
  sudo cp nixos/{{name}}/*.nix /etc/nixos/ && sudo nixos-rebuild switch  

deploy-starship:
  cp home/.config/starship.toml ~/.config/starship.toml