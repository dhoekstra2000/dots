{ config, pkgs, ... }:

{
  imports = [
    ../homeModules
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "douwe";
  home.homeDirectory = "/home/douwe";

  targets.genericLinux.enable = true;

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.iosevka
    pkgs.cascadia-code
  ];

  # This hopefully solves the refresh of the apps manu
  xdg = {
    enable = true;
    mime.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Douwe Hoekstra";
        email = "dev@dhoekstra.xyz";
      };
      init.defaultBranch = "main";
    };
  };

  my-emacs.enable = true;

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs) scheme-full;
    };
  };

  programs.thunderbird = {
    enable = true;
    languagePacks = [ "en-GB" "nl" ];
  };

  programs.sioyek = {
    enable = true;
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
