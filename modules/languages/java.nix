{
  pkgs,
  lib,
  languages,
  ...
}:
if languages.java or null == null then
  { }
else
  {
    # plugins.lsp.servers.jdtls.enable = true;
    plugins.java = {
      enable = true;
      # settings = {
      #   java.configuration.runtimes = [
      #     {
      #       name = "Java-21";
      #       path = pkgs.openjdk21;
      #       default = true;
      #     }
      #   ];
      #   root_markers = [
      #     "settings.gradle"
      #     "settings.gradle.kts"
      #     "pom.xml"
      #     "build.gradle"
      #     "mvnw"
      #     "gradlew"
      #     "build.gradle"
      #     "build.gradle.kts"
      #     "*.iml"
      #     ".git"
      #   ];
      # };
    };
    # plugins.jdtls = {
    #   enable = true;
    #   settings.cmd = [
    #     (lib.getExe' pkgs.jdt-language-server "jdtls")
    #   ];
    # };
  }
