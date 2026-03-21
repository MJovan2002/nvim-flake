{ config, lib, ... }:
lib.mkIf config.languages.csharp.enable {
  plugins = {
    # lsp.servers.csharp_ls.enable = true;
    # lsp.servers.omnisharp.enable = true;
    lsp.servers.roslyn_ls.enable = true;
  };
}
