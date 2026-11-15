{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.web;
  tsHints = {
    includeInlayParameterNameHints = "literals";
    includeInlayParameterNameHintsWhenArgumentMatchesName = false;
    includeInlayFunctionParameterTypeHints = true;
    includeInlayVariableTypeHints = false;
    includeInlayPropertyDeclarationTypeHints = true;
    includeInlayFunctionLikeReturnTypeHints = true;
    includeInlayEnumMemberValueHints = true;
  };
in
lib.mkIf cfg.enable {
  extraPackages = [
    pkgs.prettierd
    pkgs.prettier
  ];

  plugins = {
    lsp.servers = {
      # Uses the project's node_modules/typescript when present.
      ts_ls = {
        enable = true;
        settings = {
          typescript.inlayHints = tsHints;
          javascript.inlayHints = tsHints;
        };
      };
      html.enable = true;
      cssls.enable = true;
      jsonls.enable = true;
      # Templates (html / htmlangular) + component TS. Resolves @angular/language-service
      # and typescript from the project's node_modules, so run `npm install` first.
      angularls.enable = cfg.angular.enable;
    };

    conform-nvim.settings = {
      formatters_by_ft =
        lib.genAttrs
          [
            "typescript"
            "javascript"
            "typescriptreact"
            "javascriptreact"
            "html"
            "htmlangular"
            "css"
            "scss"
            "json"
            "jsonc"
          ]
          (_: {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          });
    };
  };
}
