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

      # Definitions in libraries / the JDK come back as jar:// or jrt:/ URIs, which
      # nvim cannot read (empty buffer -> pickers fail with "cursor out of range").
      # Ask the server to decompile them, like intellij.nvim does.
      autoCmd = [
        {
          event = "BufReadCmd";
          pattern = [
            "jar://*"
            "jrt:/*"
          ];
          callback.__raw = ''
            function(ev)
              local buf, uri = ev.buf, ev.match
              local bo = vim.bo[buf]
              bo.buftype = "nofile"   -- keeps vim.lsp.enable() from treating it as a project file
              bo.swapfile = false
              local function set(lines)
                bo.readonly, bo.modifiable = false, true
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                bo.modifiable, bo.modified, bo.readonly = false, false, true
              end
              local client = vim.lsp.get_clients({ name = "intellij" })[1]
              if not client then
                return set({ "intellij: no running language server to decompile " .. uri })
              end
              -- Synchronous: show_document()/pickers move the cursor right after loading.
              local res, err = client:request_sync("workspace/executeCommand", {
                command = "decompile",
                arguments = { uri },
              }, 30000, buf)
              local result = res and res.result
              if not result then
                local msg = res and res.err and res.err.message or err or "no result"
                return set({ "intellij: cannot decompile " .. uri .. ": " .. msg })
              end
              set(vim.split(result.code, "\r?\n"))
              bo.filetype = result.language or "java"
              vim.lsp.buf_attach_client(buf, client.id)
            end
          '';
        }
        {
          # Requests sent before indexing finishes come back empty/cancelled. The server
          # asks for a semanticTokens + diagnostic refresh afterwards, but not for inlay
          # hints or code lens, so those only appeared after moving the cursor.
          event = "LspProgress";
          pattern = "end";
          callback.__raw = ''
            function(ev)
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              if not client or client.name ~= "intellij" then
                return
              end
              local ctx = { client_id = client.id, method = "" }
              for _, m in ipairs({ "workspace/inlayHint/refresh", "workspace/codeLens/refresh" }) do
                ctx.method = m
                pcall(vim.lsp.handlers[m], nil, nil, ctx)
              end
            end
          '';
        }
      ];

      lsp.inlayHints.enable = true;

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
          # Answered to the server's `workspace/configuration` request for section
          # "jetbrains.java" (keys from the VS Code extension, spaces included).
          # Without it the server enables no inlay hints at all.
          settings.jetbrains.java = {
            hints = {
              "collapse complex types" = true;
              settings."method parameter" = true;
              types = {
                "local variable" = true;
                "call chain" = true;
              };
            };
            settings.types."lambda parameter" = true;
          };
          # IntelliJ cancels pull-diagnostic requests (e.g. while indexing) with
          # `"data": null`; nvim 0.12's handler only checks `error.data == nil`
          # and crashes indexing vim.NIL. Normalize it before delegating.
          handlers."textDocument/diagnostic".__raw = ''
            function(err, result, ctx)
              if err ~= nil and err.data == vim.NIL then
                err.data = nil
              end
              return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
            end
          '';
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
