self:
{
  config,
  inputs,
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
  options.programs.lazyvim.extras.util.mini-hipatterns = {
    enable = mkEnableOption "the util.mini-hipatterns extra";
  };

  config = mkIf cfg.extras.util.mini-hipatterns.enable {
    programs.neovim = {
      plugins = [cfg.pkgs.vimPlugins.mini-hipatterns];
    };
  };
}
