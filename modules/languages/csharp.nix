{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.languages.csharp.enable {
  extraPackages = [ pkgs.netcoredbg ];

  plugins = {
    lsp.servers.roslyn_ls.enable = true;
    dap.adapters.executables.coreclr = {
      command = lib.getExe pkgs.netcoredbg;
      args = [ "--interpreter=vscode" ];
    };
  };

  extraConfigLua = ''
    require("dap").configurations.cs = {
      {
        type = "coreclr",
        request = "launch",
        name = "Launch",
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
    }
  '';
}
