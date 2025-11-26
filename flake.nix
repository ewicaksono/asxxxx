{
  description = "ASxxxx Nixified, flaked";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs: 
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];

    perSystem = { self', pkgs, system, ... }:
    {
      packages = {
        default = self'.packages.asxxxx;
        asxxxx = pkgs.stdenv.mkDerivation rec {
          pname = "asxxxx";
          version = "5p50";
          src = pkgs.fetchurl {
            url = "https://shop-pdp.net/_ftp/asxxxx/asxv${version}.zip";
            hash = "sha256-A9i1Cqjj0kFPCWqOcXw3FxCaESXU9kxsRAcFmuedhc4=";
          };
          srcRoot = "asxv5pxx";
          nativeBuildInputs = [ pkgs.unzip ];
          dontConfigure = true;
          
          buildPhase = ''
            make -C ./asxmak/linux/build
          '';
          
          installPhase = ''
           mkdir -p $out/bin
           install -Dm755 ./asxmak/linux/exe/as* -t $out/bin
           install -Dm755 ./asxmak/linux/exe/s19os9 -t $out/bin
          '';

          meta = with pkgs.lib; {
            description = "ASxxxx Cross Assemblers";
            homepage = "https://shop-pdp.net/ashtml/";
            licenses = licenses.gpl;
            platforms = platforms.unix;
          };
        };
      };
    };
  };
}
# vim: set et ts=2 sts=2 sw=2 :
