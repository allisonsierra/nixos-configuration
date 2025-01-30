# nixos-configuration

NixOS configurations for my various systems along with a justfile for deploying and maintaing NixOS systems.

## Requirements

- nix
- direnv (optional but recommended)

## Directory Structure

```
nixos
└───<hostname>
│   │   configuration.nix
│   │
<tech>
│   
└───<hostname>
    │   file001.txt
```

## Deploying a NixOS Configuration

```shell
just deploy-nixos <hostname>
```
