{ pkgs, languages, ... }:
if languages.cpp or null == null then
  { }
else
  {
    plugins = {
      lsp.servers.clangd.enable = true;
      # conform-nvim.settings.formatters_by_ft.cpp = [ "clang-format" ];
    };
  }
