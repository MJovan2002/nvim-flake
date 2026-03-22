{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      git.enabled = true;
      lazygit.enable = true;
      notifier.enabled = true;
      notify.enabled = true;
      indent.enabled = true;
      input.enabled = true;
      picker.enabled = true;
      scope.enabled = true;
      scroll.enabled = true;
      statuscolumn = {
        enabled = false;
        folds = {
          open = true;
          git_hl = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>lua Snacks.picker.smart()<CR>";
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>fF";
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options.desc = "Grep Files";
    }
    {
      mode = "n";
      key = "<leader>fW";
      action = "<cmd>lua Snacks.picker.grep({hidden = false})<CR>";
      options.desc = "Grep Files";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options.desc = "Find Buffer";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>lua Snacks.picker.help()<CR>";
      options.desc = "Find Help";
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
      options.desc = "Find Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>ft";
      action = "<cmd>lua Snacks.picker.treesitter()<CR>";
      options.desc = "Find Treesitter";
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = "<cmd>lua Snacks.picker.marks()<CR>";
      options.desc = "Find Marks";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>lua Snacks.picker.resume()<CR>";
      options.desc = "Snacks resume";
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
      options.desc = "Implementation";
    }
    {
      mode = "n";
      key = "<leader>lR";
      action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
      options.desc = "References";
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>lua Snacks.notifier.show_history()<CR>";
      options.desc = "References";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit.open()<CR>";
      options.desc = "Lazygit";
    }
  ];
}
