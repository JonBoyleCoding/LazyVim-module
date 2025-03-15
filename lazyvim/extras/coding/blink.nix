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
  options.programs.lazyvim.extras.coding.blink = {
    enable = mkEnableOption "the coding.blink extra" // {
      default = cfg.enable && !cfg.extras.coding.nvim-cmp.enable;
    };
  };

  config = mkIf cfg.extras.coding.blink.enable {
    programs.neovim = {
      plugins = builtins.attrValues {inherit (cfg.pkgs.vimPlugins) blink-cmp friendly-snippets;};
    };
  };
}
