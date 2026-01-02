{ pkgs, languages, ... }:
if languages.csharp or null == null then
  { }
else
  {
    plugins = {
      # lsp.servers.csharp_ls.enable = true;
      # lsp.servers.omnisharp.enable = true;
      lsp.servers.roslyn_ls.enable = true;
    };
  }
