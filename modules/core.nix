{
  pkgs,
  ...
}:
{
  globals.mapleader = " ";

  clipboard.register = "unnamedplus";

  opts = {
    autoindent = true;
    expandtab = true;
    hidden = true;
    helpheight = 9999;
    ignorecase = true;
    incsearch = true;
    list = true;
    listchars = "tab:· ,trail:·,nbsp:␣";
    number = true;
    relativenumber = true;
    # scrolloff = 15;
    shiftwidth = 4;
    signcolumn = "yes";
    smartcase = true;
    softtabstop = 4;
    tabstop = 4;
    termguicolors = true;
    updatetime = 100;
    shell = "fish";
    linebreak = true;
    wrap = false;
    mousemoveevent = true;
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>confirm q<CR>";
      options.desc = "Close window";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>confirm qa<CR>";
      options.desc = "Quit Neovim";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Save Buffer";
    }
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>bd<CR>";
      options.desc = "Close Buffer";
    }
    {
      mode = "n";
      key = "<leader>C";
      action = "<cmd>bd!<CR>";
      options.desc = "Force close Buffer";
    }
    {
      mode = "n";
      key = "<leader>n";
      action = "<cmd>enew<CR>";
      options.desc = "New Buffer";
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "gcc";
      options = {
        desc = "Toggle comment";
        remap = true;
      };
    }
    {
      mode = "x";
      key = "<leader>/";
      action = "gc";
      options = {
        desc = "Toggle comment";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "|";
      action = "<cmd>vsplit<CR>";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      key = "\\";
      action = "<cmd>split<CR>";
      options.desc = "Horizontal split";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Move down a window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Move up a window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }
    {
      mode = "x";
      key = "<Tab>";
      action = ">gv";
      options.desc = "Indent line";
    }
    {
      mode = "x";
      key = "<S-Tab>";
      action = "<gv";
      options.desc = "Unindent line";
    }
    {
      mode = "n";
      key = "<leader>O";
      action = "<cmd>Oil<CR>";
      options.desc = "Open dir in Oil";
    }
  ];

  plugins = {
    arrow = {
      enable = true;
      settings = {
        separate_by_branch = true;
        buffer_leader_key = "-";
        show_icons = true;
        window.border = "rounded";
        per_buffer_config.satellite.enable = true;
      };
    };
    auto-session = {
      enable = true;
      settings = {
        git_use_branch_name = true;
        git_auto_restore_on_branch_change = true;
        post_restore_cmds = [
          {
            __raw = ''
              function()
                require("arrow.git").refresh_git_branch()
                require("arrow.persist").load_cache_file() 
              end
            '';
          }
        ];
      };
    };

    comment.enable = true;
    fugit2.enable = true;
    # hardtime.enable = true;
    # hex.enable = true;
    noice = {
      enable = true;
      settings = {
        notify.enabled = false;
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
      };
    };
    nvim-autopairs.enable = true;
    oil.enable = true;
    todo-comments.enable = true;
    nvim-surround.enable = true;
    perfanno.enable = true;
    spectre.enable = true;
    which-key = {
      enable = true;
      settings = {
        preset = "helix";
      };
    };
  };

  extraPlugins = [
    pkgs.vimPlugins.webapi-vim
    pkgs.vimPlugins.vim-cool
  ];
}
