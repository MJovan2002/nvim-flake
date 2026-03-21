{ pkgs, ... }:
{
  extraPackages = [ pkgs.tree-sitter ];
  plugins = {
    treesitter = {
      enable = true;
      # folding = true;
      settings = {
        highlight.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = false;
            node_decremental = "<C-S-w>";
            node_incremental = "<C-w>";
            scope_incremental = false;
          };
        };
      };
    };
    treesitter-context.enable = true;
  };
}
