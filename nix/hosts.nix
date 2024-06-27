{inputs, ...}: {
  flake = {
    config,
    lib,
    ...
  }: let
    inherit
      (lib)
      filterAttrs
      genAttrs
      mapAttrs
      ;

    # Creates a new nixosSystem with the correct specialArgs, pkgs and name definition
    mkHost = {minimal}: name: let
      pkgs = config.pkgs.x86_64-linux;
    in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          # Use the correct instance lib that has our overlays
          inherit (pkgs) lib;
          inherit (config) nodes globals;
          inherit inputs minimal;
        };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            node.name = name;
          }
          ../hosts/${name}
        ];
      };

    # Get all folders in hosts/
    hosts = builtins.attrNames (filterAttrs (_: type: type == "directory") (builtins.readDir ../hosts));
  in {
    nixosConfigurations = genAttrs hosts (mkHost {minimal = false;});
    nixosConfigurationsMinimal = genAttrs hosts (mkHost {minimal = true;});

    nodes = config.nixosConfigurations;
    # Add a shorthand to easily target toplevel derivations
    "@" = mapAttrs (_: v: v.config.system.build.toplevel) config.nodes;
  };
}
