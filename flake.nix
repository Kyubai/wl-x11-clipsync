{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      name = "clipsync";
      script = builtins.readFile ./clipsync.py;
      program =
        pkgs.writers.writePython3Bin name
        {
          doCheck = false;
          makeWrapperArgs = [
            "--prefix"
            "PATH"
            ":"
            "${pkgs.lib.makeBinPath [
              pkgs.clipnotify
              pkgs.which
              pkgs.wl-clipboard
              pkgs.xclip
            ]}"
          ];
        }
        script;
    in {
      packages = {
        "${name}" = program;
        default = self.packages.${system}.${name};
      };
    });
}
