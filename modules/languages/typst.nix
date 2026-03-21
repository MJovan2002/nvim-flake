{ config, lib, ... }:
lib.mkIf config.languages.typst.enable {
  plugins = {
    lsp.servers.tinymist.enable = true;
    typst-preview.enable = true;
  };
}
