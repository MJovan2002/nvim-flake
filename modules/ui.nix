{
  lib,
  pkgs,
  ...
}:
{
  colorschemes.vscode.enable = true;

  plugins = {
    bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        numbers = lib.nixvim.mkRaw ''
          function(opts)
            return string.format('%s %s', opts.raise(opts.id), opts.raise(opts.ordinal))
          end
        '';
        hover = {
          enabled = true;
          reveal = [ "close" ];
        };
        diagnostics_indicator = lib.nixvim.mkRaw ''
          function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        '';
      };
    };
    cursorline.enable = true;
    gitsigns.enable = true;
    rainbow-delimiters.enable = true;
    transparent = {
      enable = true;
      settings = {
        extra_groups = [
          "NormalFloat"
          "FloatBorder"
          "UfoFoldedBg"
          "UfoFoldedFg"
        ];
        exclude_groups = [
          "CursorLine"
        ];
      };
    };
    # trouble.enable = true;
    web-devicons.enable = true;
    lualine = {
      enable = true;
      settings = {
        extensions = [ "oil" ];
        sections = {
          lualine_c = [
            (lib.nixvim.mkRaw ''
              function()
                return require('arrow.statusline').text_for_statusline_with_icons()
              end
            '')
          ];
          lualine_y = [
            {
              __unkeyed = lib.nixvim.mkRaw "require('noice').api.status.search.get";
              cond = lib.nixvim.mkRaw "require('noice').api.status.search.has";
            }
            {
              __unkeyed = lib.nixvim.mkRaw "require('noice').api.status.mode.get";
              cond = lib.nixvim.mkRaw "require('noice').api.status.mode.has";
            }
            # {
            #   __unkeyed = (lib.nixvim.mkRaw "require('noice').api.status.command.get");
            #   cond = (lib.nixvim.mkRaw "require('noice').api.status.command.has");
            # }
            { __unkeyed = "progress"; }
          ];
        };
      };
    };
    nvim-ufo = {
      enable = true;
      settings.preview = {
        win_config.winblend = 0;
        mappings = {
          scrollU = "<C-u>";
          scrollD = "<C-d>";
          jumpTop = "[";
          jumpBot = "]";
        };
      };
    };
    tiny-inline-diagnostic.enable = true;
    oil-git-status.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "]b";
      action = "<Cmd>BufferLineCycleNext<CR>";
      options.desc = "Next Buffer";
    }
    {
      mode = "n";
      key = "[b";
      action = "<Cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous Buffer";
    }
    {
      mode = "n";
      key = "K";
      action = lib.nixvim.mkRaw ''
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end
      '';
      options.desc = "Peek fold";
    }
  ];

  autoCmd = [
    {
      event = [
        "CursorHold"
        "CursorHoldI"
      ];
      callback = lib.nixvim.mkRaw "vim.lsp.buf.document_highlight";
    }
    {
      event = [
        "CursorMoved"
      ];
      callback = lib.nixvim.mkRaw "vim.lsp.buf.clear_references";
    }
  ];

  extraPlugins = [
    pkgs.vimPlugins.satellite-nvim
  ];
}
