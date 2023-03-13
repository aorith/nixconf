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
	@nix flake lock --update-input private
	sudo nixos-rebuild switch --flake .#

boot:
	@nix flake lock --update-input private
	sudo nixos-rebuild boot --flake .#

dry-build:
	@nix flake lock --update-input private
	sudo nixos-rebuild dry-build --flake .#

dry-activate:
	@nix flake lock --update-input private
	sudo nixos-rebuild dry-activate --flake .#

update:
	nix flake update

shell:
	nix-shell

clean:
	@echo "Running garbage collector ..."
	sudo nix-store --gc
	@echo "Running deduplication of the Nix store... may take a while"
	sudo nix-store --optimise
