{ lib, ... }:
{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
          { name = "crates"; }
          { name = "buffer"; }
        ];
        experimental.ghost_text = true;
        formatting.format = lib.nixvim.mkRaw ''
          function(entry, item)
            local kind_icon = require("lspkind").cmp_format({ mode = "symbol" })(entry, vim.deepcopy(item))
            local highlight_item = require("colorful-menu").cmp_highlights(entry, item)
            if highlight_item then
              item.abbr_hl_group = highlight_item.highlights
              item.abbr = highlight_item.text
            end
            item.kind = kind_icon.kind
            return item
          end
        '';
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };
    };
    colorful-menu.enable = true;
  };
}
