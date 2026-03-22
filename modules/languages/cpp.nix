{ config, lib, ... }:
lib.mkIf config.languages.cpp.enable {
  plugins = {
    lsp.servers.clangd.enable = true;
  };
}
