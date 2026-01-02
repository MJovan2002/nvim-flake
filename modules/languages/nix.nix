{
  lib,
  pkgs,
  languages,
  ...
}:
if languages.nix or null == null then
  { }
else
  {
    # plugins.lsp.servers.nil_ls.enable = languages.nix;
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
