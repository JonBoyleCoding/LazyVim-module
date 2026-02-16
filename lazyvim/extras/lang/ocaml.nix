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
  options.programs.lazyvim.extras.lang.ocaml = {
    enable = mkEnableOption "the lang.ocaml extra";
  };

  config = mkIf cfg.extras.lang.ocaml.enable {
    programs.neovim = {
      extraPackages = [ cfg.pkgs.ocamlPackages.ocaml-lsp ];

      plugins = [
        (cfg.pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [ plugins.ocaml ]))
      ];
    };
  };
}
