[
  (_final: prev: {
    deploy = prev.callPackage ./deploy.nix {};
    formats =
      prev.formats
      // {
        ron = import ./ron.nix {inherit (prev) lib pkgs;};
      };
  })
]
