#!/usr/bin/env bash

rebuild_type=$1

function display_help {
  echo -e "Usage: ./rebuild.sh <target>\n"
  echo "Available targets:"
  echo "  nixos    rebuild NixOS system for the current host"
  echo "  darwin   rebuild Darwin system for the current host"
  echo "  home     rebuild home configuration for the current user@host"
}

if ! command -v nix 2>&1 >/dev/null; then
	echo "nix not found. Installing nix..."
	./bootstrap/nix.sh
fi

if [ -z $rebuild_type ]; then
  echo -e "Simple configuration build script (cause I always forget these commands)\n"
  display_help
  exit 1
elif [ $rebuild_type == "nixos" ]; then
	nixos-rebuild switch --flake .#"$(hostname)"
elif [ $rebuild_type == "darwin" ]; then
	if ! command -v brew 2>&1 >/dev/null; then
		echo "brew not found. Installing brew..."
		./bootstrap/brew.sh
	fi
	echo "Rebuilding Darwin system..."
	if command -v darwin-rebuild 2>&1 >/dev/null; then
		darwin-rebuild switch --flake .#"$(hostname)"
	else
		echo "nix-darwin not found. Installing nix-darwin..."
		nix run nix-darwin -- switch --flake .#"$(hostname)"
	fi
elif [ $rebuild_type == "home" ]; then
	echo "Rebuilding home configuration..."
	if command -v home-manager 2>&1 >/dev/null; then
		home-manager switch --flake '.?submodules=1'
	else
		echo "home-manager not found. Installing home-manager..."
		nix run home-manager -- switch --flake '.?submodules=1'
	fi
else
	echo -e "Invalid target. Please provide either nixos, darwin, or home\n"
	display_help
	exit 1
fi
