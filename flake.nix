{
  description = "ToDo em Flask, empacotado com Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      todo = pkgs.python3Packages.buildPythonApplication {
        pname = "todo-demo";
        version = "1.0";
        pyproject = true;
        src = ./.;
        build-system = [ pkgs.python3Packages.setuptools ];
        dependencies = [ pkgs.python3Packages.flask ];
      };
    in
    {
      packages.${system} = {
        default = todo;
        # nix build .#container
        container = pkgs.dockerTools.buildLayeredImage {
          name = "todo-demo";
          tag = "latest";
          config.Cmd = [ "${todo}/bin/todo-demo" ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          (pkgs.python3.withPackages (ps: [ ps.flask ]))
        ];
      };
    };
}
