{
  lib,
  ...
}:
{
  imports =
    ./.
    |> builtins.readDir
    |> lib.attrsToList
    |> builtins.map ({ name, ... }: name)
    |> builtins.filter (name: name != "default.nix")
    |> builtins.map (name: ./${name});

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
    lspkind.enable = true;
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
      key = "<leader>ll";
      action = "<cmd>lua require('lsp_lines').toggle()<CR>";
      options.desc = "Toggle Lines";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>la";
      action = "<cmd>lua require('actions-preview').code_actions()<CR>";
      options.desc = "Lsp Code Actions";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
      options.desc = "Lsp Rename";
    }
    {
      mode = "n";
      key = "gd";
      action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
      options.desc = "Lsp Goto Definition";
    }
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
    {
      mode = "n";
      key = "<leader><space>";
      action = "<cmd>lua vim.lsp.codelens.run()<CR>";
      options.desc = "Run";
    }
  ];

  autoCmd = [
    {
      event = [
        "BufEnter"
        "CursorHold"
        "InsertLeave"
      ];
      callback = lib.nixvim.mkRaw "vim.lsp.codelens.refresh";
    }
  ];
}
