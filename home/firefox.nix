{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override { enableTridactylNative = true; };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      onepassword-password-manager
      tridactyl
      https-everywhere
      privacy-badger
      sponsorblock
      ublock-origin
      decentraleyes
      facebook-container
      firenvim
    ];
  };
}
