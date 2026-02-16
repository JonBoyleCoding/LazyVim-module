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
  options.programs.lazyvim.extras.lang.svelte = {
    enable = mkEnableOption "the lang.svelte extra";
  };

  config = mkIf cfg.extras.lang.svelte.enable {
    programs.lazyvim = {
      masonPackages = {
        "svelte-language-server/node_modules/typescript-svelte-plugin" =
          self.packages.${cfg.pkgs.stdenv.hostPlatform.system}.typescript-svelte-plugin;
      };
    };

    programs.neovim = {
      extraPackages = [cfg.pkgs.svelte-language-server];

      plugins = [(cfg.pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [plugins.svelte]))];
    };
  };
}
