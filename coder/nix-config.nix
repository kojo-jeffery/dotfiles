{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.code-server,pkgs.git,pkgs.tmux,pkgs.neovim,pkgs.neofetch,pkgs.fzf,pkgs.eza, pkgs.starship ];
}