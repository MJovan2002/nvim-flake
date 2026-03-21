{ config, lib, ... }:
lib.mkIf config.languages.python.enable {
  extraPackages = [ config.languages.python.black ];

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
