{
  lib,
  ...
}:
{
  colorschemes.vscode.enable = true;

  plugins = {
    dashboard = {
      enable = true;
      settings.theme = "hyper";
    };
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
    # nvim-ufo.enable = true;
    # origami = {
    #   enable = true;
    #   settings.foldKeymaps.setup = true;
    # };
    tiny-inline-diagnostic.enable = true;
    oil-git-status.enable = true;
    scrollview.enable = true;
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
    # {
    #   mode = "n";
    #   key = "zp";
    #   action = "<Cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>";
    #   options.desc = "Peek fold";
    # }
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
}
