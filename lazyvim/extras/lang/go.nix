self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.lazyvim;
in
{
  options.programs.lazyvim.extras.lang.go = {
    enable = mkEnableOption "the lang.go extra";
  };

  config = mkIf cfg.extras.lang.go.enable {
    programs.neovim = {
      extraPackages =
        attrValues { inherit (cfg.pkgs) gofumpt gopls gotools; }
        ++ optional cfg.extras.dap.core.enable cfg.pkgs.delve;
      # TODO: ++ optionals cfg.extras.lsp.none-ls.enable (attrValues {
      #   inherit (pkgs) gomodifytags impl;
      # });

      plugins =
        [
          (cfg.pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins:
            attrValues {
              inherit (plugins)
                go
                gomod
                gosum
                gowork
                ;
            }
          ))
        ]
        ++ optional cfg.extras.dap.core.enable cfg.pkgs.vimPlugins.nvim-dap-go
        ++ optional cfg.extras.test.core.enable cfg.pkgs.vimPlugins.neotest-golang;
    };
  };
}
