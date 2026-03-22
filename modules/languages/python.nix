{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.languages.python.enable {
  extraPackages = [
    config.languages.python.black
    pkgs.ruff
    pkgs.debugpy
  ];

  plugins = {
    lsp.servers = {
      basedpyright = {
        enable = true;
        settings.basedpyright.analysis = {
          inlayHints = {
            variableTypes = true;
          };
          useTypingExtensions = true;
        };
      };
      ruff.enable = true;
    };
    conform-nvim.settings.formatters_by_ft.python = [
      "ruff_organize_imports"
      "ruff_format"
      "black"
    ];
    dap.adapters.executables.debugpy = {
      command = lib.getExe pkgs.debugpy;
      args = [
        "-m"
        "debugpy.adapter"
      ];
    };
  };

  extraConfigLua = ''
    require("dap").configurations.python = {
      {
        type = "debugpy",
        request = "launch",
        name = "Launch file",
        program = "''${file}",
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then return venv .. "/bin/python" end
          return "python3"
        end,
      },
    }
  '';
}
