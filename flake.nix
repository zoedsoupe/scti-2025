{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
  };

  outputs = {
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs.lib) genAttrs;
    inherit (nixpkgs.lib.systems) flakeExposed;
    forAllSystems = f:
      genAttrs flakeExposed (system:
        f (import nixpkgs {
          inherit system;
        }));
  in {
    devShells = forAllSystems (pkgs: let
      inherit (pkgs) mkShell;
    in {
      default = mkShell {
        name = "nyxvamp-slidev";
        packages = with pkgs; [
          bun
          nodejs_22
          typescript
          nodePackages.npm
        ] ++ lib.optional stdenv.isLinux [inotify-tools];
      };
    });
  };
}
