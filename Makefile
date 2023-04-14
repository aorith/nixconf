CURRENTUID := $(shell id -u)

ifeq ($(CURRENTUID), 0)
  $(error Run without root)
endif

.PHONY: switch boot dry-build update shell clean bootstrap

main:
	@echo "Avalable options: "
	@grep -Eo '^[a-zA-Z]+:' Makefile | grep -v '[m]ain:' | tr -d ':' | xargs -n1 echo "    make"

bootstrap:
	./scripts/bootstrap.sh

switch:
	sudo nixos-rebuild switch -L --flake .#

boot:
	sudo nixos-rebuild boot -L --flake .#

dry-build:
	sudo nixos-rebuild dry-build -L --flake .#

dry-activate:
	sudo nixos-rebuild dry-activate -L --flake .#

update:
	nix flake update

shell:
	nix-shell

clean:
	@echo "Running garbage collector ..."
	sudo nix-store --gc
	@echo "Running deduplication of the Nix store... may take a while"
	sudo nix-store --optimise
