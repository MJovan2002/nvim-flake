{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.java;
in
lib.mkIf cfg.enable (
  lib.mkMerge [
    (lib.mkIf (cfg.lsp == "jdtls") {
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
    })

    # JetBrains IntelliJ language server. The `intellij-lsp` wrapper (EULA check,
    # per-project system dir, stdio) comes from `cfg.intellij.package`, or from
    # PATH (e.g. the project's devShell) when that is null.
    (lib.mkIf (cfg.lsp == "intellij") {
      extraPackages = lib.optional (cfg.intellij.package != null) cfg.intellij.package;
      lsp.servers.intellij = {
        enable = true;
        config = {
          cmd.__raw = ''
            function(dispatchers, config)
              return vim.lsp.rpc.start(
                { "intellij-lsp", config.root_dir or vim.fn.getcwd() },
                dispatchers,
                { cwd = config.root_dir }
              )
            end
          '';
          filetypes = [ "java" ];
          # Outermost pom.xml (multi-module Maven), else Gradle / git root.
          root_dir.__raw = ''
            function(bufnr, on_dir)
              local dir = vim.fs.root(bufnr, "pom.xml")
              while dir do
                local parent = vim.fs.dirname(dir)
                if parent == dir or not vim.uv.fs_stat(vim.fs.joinpath(parent, "pom.xml")) then
                  break
                end
                dir = parent
              end
              on_dir(dir or vim.fs.root(bufnr, {
                "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "mvnw", ".git",
              }))
            end
          '';
        };
      };
    })
  ]
)
