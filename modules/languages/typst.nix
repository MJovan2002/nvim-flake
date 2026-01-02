{ languages, ... }:
if languages.typst or null == null then
  { }
else
  {
    plugins = {
      lsp.servers.tinymist.enable = true;
      typst-preview.enable = true;
    };
  }
