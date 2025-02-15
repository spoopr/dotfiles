{
  pkgs,
  ...
}: pkgs.stdenv.mkDerivation {
  pname = "enhanced-enchantment";
  version = "1.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp $src/enhancedEnchantment.ttf $out/share/fonts/truetype/
  '';
}
  
