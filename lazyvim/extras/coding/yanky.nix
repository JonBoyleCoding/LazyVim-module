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
  options.programs.lazyvim.extras.coding.yanky = {
    enable = mkEnableOption "the coding.yanky extra";
  };

  config = mkIf cfg.extras.coding.yanky.enable {
    programs.neovim = {
      plugins = [cfg.pkgs.vimPlugins.yanky-nvim];
    };
  };
}
