{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.languages.nix.enable {
  # plugins.lsp.servers.nil_ls.enable = true;
  plugins = {
    lsp.servers = {
      nixd.enable = true;
      statix.enable = true;
    };
    conform-nvim.settings = {
      formatters_by_ft.nix = [ "nixfmt" ];
      formatters.nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
    };
  };
}
