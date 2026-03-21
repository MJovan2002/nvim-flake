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
    treesitter-textobjects.enable = true;
  };

  extraConfigLua = ''
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- Textobject selection
    local select_maps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["ai"] = "@conditional.outer",
      ["ii"] = "@conditional.inner",
    }
    for key, query in pairs(select_maps) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    -- Movement
    local next_start = {
      ["]f"] = { "@function.outer", "Next function start" },
      ["]c"] = { "@class.outer", "Next class start" },
      ["]a"] = { "@parameter.inner", "Next argument" },
      ["]l"] = { "@loop.outer", "Next loop" },
      ["]i"] = { "@conditional.outer", "Next conditional" },
    }
    local next_end = {
      ["]F"] = { "@function.outer", "Next function end" },
      ["]C"] = { "@class.outer", "Next class end" },
    }
    local prev_start = {
      ["[f"] = { "@function.outer", "Prev function start" },
      ["[c"] = { "@class.outer", "Prev class start" },
      ["[a"] = { "@parameter.inner", "Prev argument" },
      ["[l"] = { "@loop.outer", "Prev loop" },
      ["[i"] = { "@conditional.outer", "Prev conditional" },
    }
    local prev_end = {
      ["[F"] = { "@function.outer", "Prev function end" },
      ["[C"] = { "@class.outer", "Prev class end" },
    }

    for key, val in pairs(next_start) do
      vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_next_start(val[1], "textobjects") end, { desc = val[2] })
    end
    for key, val in pairs(next_end) do
      vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_next_end(val[1], "textobjects") end, { desc = val[2] })
    end
    for key, val in pairs(prev_start) do
      vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_previous_start(val[1], "textobjects") end, { desc = val[2] })
    end
    for key, val in pairs(prev_end) do
      vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_previous_end(val[1], "textobjects") end, { desc = val[2] })
    end

    -- Swap
    vim.keymap.set("n", "<leader>sa", function() swap.swap_next("@parameter.inner", "textobjects") end, { desc = "Swap with next argument" })
    vim.keymap.set("n", "<leader>sA", function() swap.swap_previous("@parameter.inner", "textobjects") end, { desc = "Swap with prev argument" })
  '';
}
