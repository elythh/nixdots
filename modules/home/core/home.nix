{
  pkgs,
  config,
  inputs,
  pkgsStable,
  ...
}: {
  home = {
    username = "gwen";
    homeDirectory = "/home/gwen";
    stateVersion = "23.11";
    file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
    file.".local/share/fonts".source = ./fonts;
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };

    packages = with pkgs; [
      inputs.nixvim.packages.${system}.default
      inputs.zjstatus.packages.${system}.default
      (pkgs.callPackage ../../../derivs/spotdl.nix {
        inherit (pkgs.python311Packages) buildPythonApplication;
      })
      (pkgs.callPackage ../../../home/shared/icons/whitesur.nix {})
      (pkgs.callPackage ../../../home/shared/icons/reversal.nix {})
      alejandra
      awscli
      betterdiscordctl
      bitwarden
      bitwarden-cli
      chatterino2
      charm
      chromium
      clipse
      colordiff
      copyq
      circumflex
      docker-compose
      easyeffects
      eza
      feh
      fx
      fzf
      gcc
      gh
      git-lfs
      gitmoji-cli
      glow
      gnumake
      pkgsStable.go
      google-cloud-sdk
      gum
      helmfile
      imagemagick
      inotify-tools
      jaq
      jq
      jqp
      just
      k9s
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      kubie
      lazygit
      light
      marksman
      mods
      networkmanagerapplet
      nix-index
      obsidian
      onefetch
      openssl
      openvpn
      operator-sdk
      papirus-icon-theme
      pavucontrol
      pfetch
      pinentry
      playerctl
      presenterm
      python311Packages.gst-python
      python311Packages.pip
      python311Packages.pygobject3
      python311Packages.setuptools
      python311Packages.virtualenv
      rbw
      rcon
      rofi-rbw
      rustup
      satty
      skim
      slack
      slides
      starship
      stern
      tailspin
      telegram-desktop
      tldr
      viddy
      wireplumber
      yarn
      zellij
      zoxide
    ];
  };
}