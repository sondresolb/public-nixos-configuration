{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sddm-astronaut-fonts";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "468a100460d5feaa701c2215c737b55789cba0fc";
    sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
  };
  installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp -a Fonts/*.ttf $out/share/fonts/truetype/
  '';
}
