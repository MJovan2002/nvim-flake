{ pkgs, languages, ... }:
if languages.python or null == null then
  { }
else
  {
    extraPackages = [ languages.python.black or pkgs.black ];

    plugins = {
      lsp.servers.basedpyright = {
        enable = true;
        settings.basedpyright.analysis = {
          inlayHints = {
            variableTypes = true;
          };
          useTypingExtensions = true;
        };
      };
      conform-nvim.settings.formatters_by_ft.python = [ "black" ];
    };
  }
