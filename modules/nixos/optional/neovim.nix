{ pkgs, ... }:

let
  neovimPlugins = pkgs.symlinkJoin {
    name = "neovim-plugins";
    paths = [
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies
      pkgs.vimPlugins.nvim-treesitter-context
      pkgs.vimPlugins.nvim-treesitter-textobjects
    ];
  };
in
{
  systemd.tmpfiles.rules = [
    "L+ /home/aorith/.config/neovim-plugins - - - - ${neovimPlugins}" # L+ recreates the symlink if neovimPlugins path is modified
  ];

  environment.systemPackages = with pkgs; [
    neovim
    neovimPlugins

    # Formatters
    black
    isort
    jsonnet # jsonnetfmt
    nixfmt-rfc-style
    prettierd
    ruff
    shfmt
    stylua
    taplo
    yamlfmt

    # Linters
    ansible-lint
    djlint
    golangci-lint
    proselint
    shellcheck
    tflint
    typos
    yamllint

    # LSP
    nil
    basedpyright
    bash-language-server
    vscode-langservers-extracted
    gopls
    lua-language-server
    marksman
    #ruff-lsp
    templ
    terraform-ls
    typescript-language-server
    yaml-language-server
  ];
}
