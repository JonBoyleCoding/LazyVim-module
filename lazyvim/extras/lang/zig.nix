self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.lazyvim;
in {
  options.programs.lazyvim.extras.lang.zig = {
    enable = mkEnableOption "the lang.zig extra";
  };

  config = mkIf cfg.extras.lang.zig.enable {
    programs.neovim = {
      extraPackages = builtins.attrValues {inherit (cfg.pkgs) zls;};

      plugins = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [ plugins.zig ]))
      ] ++ optional cfg.extras.test.core.enable pkgs.vimPlugins.neotest-zig;
    };
  };
}
