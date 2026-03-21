{ config, lib, ... }:
lib.mkIf config.languages.rust.enable {
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

  autoCmd = [
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "rust-analyzer" then return end
          local buf = args.buf
          local map = function(key, cmd, desc)
            vim.keymap.set("n", key, "<cmd>RustLsp " .. cmd .. "<CR>", { buffer = buf, desc = desc })
          end
          map("<leader>re", "expandMacro", "Expand macro")
          map("<leader>rr", "runnables", "Runnables")
          map("<leader>rd", "debuggables", "Debuggables")
          map("<leader>rp", "parentModule", "Parent module")
          map("<leader>rc", "openCargo", "Open Cargo.toml")
          map("<leader>rg", "crateGraph", "Crate graph")
          map("<leader>rm", "rebuildProcMacros", "Rebuild proc macros")
          map("<leader>rE", "explainError current", "Explain error")
          map("<leader>rj", "joinLines", "Join lines")
          map("<leader>rs", "ssr", "Structural search replace")
        end
      '';
    }
  ];
}
