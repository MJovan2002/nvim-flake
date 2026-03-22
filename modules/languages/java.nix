{ config, lib, ... }:
lib.mkIf config.languages.java.enable {
  plugins.java.enable = true;
}
