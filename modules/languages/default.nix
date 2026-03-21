{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.languages = {
    rust.enable = lib.mkEnableOption "Rust language support";
    nix.enable = lib.mkEnableOption "Nix language support";
    python = {
      enable = lib.mkEnableOption "Python language support";
      black = lib.mkOption {
        type = lib.types.package;
        default = pkgs.black;
        description = "Black formatter package";
      };
    };
    cpp.enable = lib.mkEnableOption "C++ language support";
    csharp.enable = lib.mkEnableOption "C# language support";
    java.enable = lib.mkEnableOption "Java language support";
    typst.enable = lib.mkEnableOption "Typst language support";
  };

  imports =
    ./.
    |> builtins.readDir
    |> lib.attrsToList
    |> builtins.map ({ name, ... }: name)
    |> builtins.filter (name: name != "default.nix")
    |> builtins.map (name: ./${name});

  config = {
    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
      };
      actions-preview = {
        enable = true;
        settings = {
          highlight_command = [
            (lib.nixvim.mkRaw "require('actions-preview.highlight').delta 'delta --side-by-side'")
            (lib.nixvim.mkRaw "require('actions-preview.highlight').diff_so_fancy()")
            (lib.nixvim.mkRaw "require('actions-preview.highlight').diff_highlight()")
          ];
          snacks.layout.preset = "vertical";
        };
      };
      # lsp-status.enable = true;
      lspkind = {
        enable = true;
        cmp.enable = false;
      };
      luasnip.enable = true;
      none-ls.enable = true;
      dropbar = {
        enable = true;
      };
      conform-nvim = {
        enable = true;
        settings.format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = 'fallback' }
          end
        '';
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ld";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Hover diagnostic";
      }
      {
        mode = "n";
        key = "]e";
        action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>";
        options.desc = "Next error";
      }
      {
        mode = "n";
        key = "[e";
        action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>";
        options.desc = "Prev error";
      }
      {
        mode = "n";
        key = "]w";
        action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>";
        options.desc = "Next warning";
      }
      {
        mode = "n";
        key = "[w";
        action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>";
        options.desc = "Prev warning";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Prev diagnostic";
      }
    ];

    autoCmd = [
      {
        event = "LspAttach";
        callback.__raw = ''
          function(args)
            local buf = args.buf
            local map = function(mode, key, action, desc)
              vim.keymap.set(mode, key, action, { buffer = buf, desc = desc })
            end
            map("n", "<leader>ll", "<cmd>lua require('lsp_lines').toggle()<CR>", "Toggle Lines")
            map({ "n", "v" }, "<leader>la", "<cmd>lua require('actions-preview').code_actions()<CR>", "Lsp Code Actions")
            map("n", "<leader>lr", vim.lsp.buf.rename, "Lsp Rename")
            map("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions()<CR>", "Lsp Goto Definition")
            map("n", "<leader><space>", vim.lsp.codelens.run, "Run")
          end
        '';
      }
      {
        event = [
          "BufEnter"
          "CursorHold"
          "InsertLeave"
        ];
        callback = lib.nixvim.mkRaw "vim.lsp.codelens.refresh";
      }
    ];
  };
}
