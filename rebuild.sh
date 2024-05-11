#!/usr/bin/env bash

# get passed argument for the type of rebuild (either system or home)
rebuild_type=$1

if [ -z $rebuild_type ]; then
  echo "Please provide either system or home as an argument."
  exit 1
elif [ $rebuild_type == "linux" ]; then
	sudo nixos-rebuild switch --flake .#"$(hostname)"
elif [ $rebuild_type == "darwin" ]; then
	darwin-rebuild switch --flake ./darwin
elif [ $rebuild_type == "home" ]; then
	home-manager switch --flake .#"$(whoami)$(hostname)"
else
	echo "Invalid rebuild type. Please provide either 'system' or 'home'"
	exit 1
fi



