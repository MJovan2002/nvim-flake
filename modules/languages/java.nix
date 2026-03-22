{ config, lib, pkgs, ... }:
lib.mkIf config.languages.java.enable {
  extraPackages = [ pkgs.unzip ];
  plugins = {
    java = {
      enable = true;
      settings = {
        spring_boot_tools.enable = false;
        jdk.auto_install = false;
      };
    };
    lsp.servers.jdtls = {
      enable = true;
      settings.java.inlayHints = {
        parameterNames.enabled = "all";
        typeParameters.enabled = true;
      };
    };
  };
}
