{
  pkgs,
  ...
}: let
  enhancedEnchantment = pkgs.callPackage ./enhancedEnchantment {};
in {
  fonts = {
    packages = [
      enhancedEnchantment
    ];
  };
}
