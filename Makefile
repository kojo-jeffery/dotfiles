## install: [DOCKER] Run install script - installs all dev-container requirements 
install:
	chmod +x install.sh && ./install.sh

## help: [LINUX] Command to view help
help: Makefile
	@echo
	@echo "Choose a command to run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo