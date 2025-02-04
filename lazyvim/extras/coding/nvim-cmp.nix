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
  options.programs.lazyvim.extras.coding.nvim-cmp = {
    enable = mkEnableOption "the coding.nvim-cmp extra" // {
      default = cfg.enable && !cfg.extras.coding.blink.enable;
    };
  };

  config = mkIf cfg.extras.coding.blink.enable {
    programs.neovim = {
      plugins = builtins.attrValues {
        inherit (pkgs.vimPlugins)
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          nvim-snippets
          friendly-snippets
          ;
      };
    };
  };
}
