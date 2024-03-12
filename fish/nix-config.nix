{ pkgs, stdenv }:

with stdenv;

let
  traveldev = pkgs.buildEnv {
    inherit pkgs;

    buildInputs = [
      git
      tmux
      neovim
      neofetch
      fzf
      eza
      starship
    ];
  };

in
  traveldev
