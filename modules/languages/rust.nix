{ languages, ... }:
if languages.rust or null == null then
  { }
else
  {
    dependencies.rust-analyzer.packageFallback = true;
    plugins = {
      lsp.servers = {
        taplo.enable = true;
        # bacon_ls.enable = true;
        # bacon_ls.package = null;
        # rust_analyzer.enable = true;
        # rust_analyzer.installRustc = false;
        # rust_analyzer.installCargo = false;
      };
      rustaceanvim = {
        enable = true;
        settings = {
          tools.code_actions.ui_select_fallback = true;
          server = {
            default_settings = {
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "always";
                };
              };
              rust-analyzer = {
                cargo = {
                  allFeatures = true;
                };
                check = {
                  command = "clippy";
                };
                files = {
                  excludeDirs = [
                    "target"
                    ".git"
                    ".cargo"
                    ".github"
                    ".direnv"
                  ];
                };
              };
            };
          };
        };
      };
      crates.enable = true;
      conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
    };
  }
