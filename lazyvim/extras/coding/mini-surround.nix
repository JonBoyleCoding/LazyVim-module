self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.lazyvim;
in
{
  options.programs.lazyvim.extras.coding.mini-surround = {
    enable = mkEnableOption "the coding.mini-surround extra";
  };

  config = mkIf cfg.extras.coding.mini-surround.enable {
    programs.neovim = {
      plugins = [cfg.pkgs.vimPlugins.mini-surround];
    };
  };
}
