{ pkgs, lib, config, ... }:
{
  options = {
    my-emacs.enable = lib.mkEnableOption "Enable emacs config";
  };

  config = lib.mkIf config.my-emacs.enable {
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        doom-themes
	      doom-modeline
	      orderless
	      corfu
	      vertico
	      marginalia
	      cape
	      which-key
	      pdf-tools
	      auctex
	      cdlatex
	      yasnippet
	      magit
        git-gutter
	      nix-mode
      ];
    };

    home.file."emacs-dots" = {
      target = ".emacs.d";
      recursive = true;
      source = ./dots;
    };
  };
}
