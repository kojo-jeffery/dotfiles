#!/bin/bash

set -e

# Initialize nix and install code-server (assuming default.nix)
nix-shell 

# Launch code-server
code-server --bind-addr 0.0.0.0:8080 --auth none 