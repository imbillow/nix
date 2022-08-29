{ pkgs, ... }: {
  home = {
    username = "aya";
    homeDirectory = "/home/aya";
    stateVersion = "22.11";
    packages = with pkgs; [
      kitty
      google-chrome
      jetbrains.clion
      jetbrains.idea-ultimate
      spotify
    ];
    file = { };
  };
  programs = {
    home-manager.enable = true;
    emacs.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
