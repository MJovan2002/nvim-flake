{ config, lib, ... }:
lib.mkIf config.languages.cpp.enable {
  plugins = {
    lsp.servers.clangd.enable = true;
    # conform-nvim.settings.formatters_by_ft.cpp = [ "clang-format" ];
  };
}
