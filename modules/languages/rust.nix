{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.languages.rust.enable {
  dependencies.rust-analyzer.packageFallback = true;
  extraPackages = [ pkgs.bacon ];
  plugins = {
    lsp.servers = {
      taplo.enable = true;
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

  extraConfigLua = ''
    local function snacks_show_references(command)
      local locations = command.arguments[3]
      if not locations or #locations == 0 then return end
      if #locations == 1 then
        vim.lsp.util.show_document(locations[1], "utf-8", { focus = true })
      else
        vim.fn.setqflist(vim.lsp.util.locations_to_items(locations, "utf-8"))
        Snacks.picker.qflist()
      end
    end

    local function snacks_goto_location(command)
      local location = command.arguments[1]
      if location then
        vim.lsp.util.show_document(location, "utf-8", { focus = true })
      end
    end
  '';

  autoCmd = [
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "rust-analyzer" then return end
          client.commands["rust-analyzer.showReferences"] = snacks_show_references
          client.commands["rust-analyzer.gotoLocation"] = snacks_goto_location
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
