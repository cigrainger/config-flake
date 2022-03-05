{ pkgs, ... }: {
  home.packages = with pkgs; [ gtk3 ];
  programs.firefox = {
    enable = true;
    package =
      pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      decentraleyes
      facebook-container
      firenvim
      https-everywhere
      onepassword-password-manager
      privacy-badger
      sponsorblock
      tridactyl
      ublock-origin
    ];
    profiles = {
      chris = {
        isDefault = true;
        bookmarks = {
          "Bank Australia" = { url = "https://digital.bankaust.com.au/"; };
          "Home Manager Options" = {
            url = "https://nix-community.github.io/home-manager/options.html";
          };
          Budget = {
            url =
              "https://docs.google.com/spreadsheets/d/1mi5moo9jskLyt4SEJTBJtF9QMoJnr4ON1pRfsJpzAEY/edit#gid=552956383";
          };
          "Search Nix" = { url = "https://search.nixos.org"; };
        };
        settings = {
          "extensions.pocket.enabled" = false;
          "media.eme.enabled" = true;
        };
      };
    };
  };
}
