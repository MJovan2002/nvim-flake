{
  pkgs,
  lib,
  ...
}:
let
  lldb = pkgs.lldb_19;
in
{
  extraPackages = [
    lldb
  ];

  plugins = {
    dap = {
      enable = true;
      adapters = {
        executables.lldb.command = lib.getExe' lldb "lldb-dap";
      };
    };
    dap-lldb.enable = true;
    dap-ui.enable = true;
    dap-rr.enable = true;
    dap-virtual-text.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<F5>";
      action = "<cmd>lua require('dap').continue()<CR>";
      options.desc = "Debugger Continue";
    }
    {
      mode = "n";
      key = "<F6>";
      action = "<cmd>lua require('dap').pause()<CR>";
      options.desc = "Debugger Pause";
    }
    {
      mode = "n";
      key = "<F7>";
      action = "<cmd>lua require('dap').terminate()<CR>";
      options.desc = "Debugger Terminate";
    }
    {
      mode = "n";
      key = "<F8>";
      action = "<cmd>lua require('dap').disconnect()<CR>";
      options.desc = "Debugger Disconnect";
    }
    {
      mode = "n";
      key = "<F9>";
      action = "<cmd>lua require('dap').step_into()<CR>";
      options.desc = "Debugger Step Into";
    }
    {
      mode = "n";
      key = "<F10>";
      action = "<cmd>lua require('dap').step_over()<CR>";
      options.desc = "Debugger Step Over";
    }
    {
      mode = "n";
      key = "<F11>";
      action = "<cmd>lua require('dap').step_out()<CR>";
      options.desc = "Debugger Step Out";
    }
    {
      mode = "n";
      key = "<F12>";
      action = "<cmd>lua require('dap').step_back()<CR>";
      options.desc = "Debugger Step Back";
    }
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      options.desc = "Debugger Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.input.input({
            prompt = 'Condition: ',
          }, function(condition)
            Snacks.input.input({
              prompt = 'Log message: ',
            }, function(message)
              require('dap').set_breakpoint(condition, nil, message)
            end)
          end)
        end
      '';
      options.desc = "Debugger Set Breakpoint";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>dh";
      action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
      options.desc = "Debugger Hover";
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require('dapui').toggle()<CR>";
      options.desc = "Debugger UI";
    }
  ];

  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
  '';
}
