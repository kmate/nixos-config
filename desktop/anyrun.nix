{
  inputs,
  system,
  osConfig,
  pkgs,
  ...
}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun-nixos-options.packages.${system}.default
        "${pkgs.anyrun}/lib/libkidex.so"
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {fraction = 0.4;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };
    extraCss = ''
      @define-color bg-color #1a1b26;
      @define-color fg-color #c0caf5;
      @define-color accent #7aa2f7;
      @define-color cyan #7dcfff;

      window {
        background: transparent;
      }

      box.main {
        padding: 2px;
        margin: 3px;
        border-radius: 6px;
        border: 1px solid @accent;
        background-color: rgba(26, 27, 38, 0.95);
      }

      text {
        min-height: 24px;
        padding: 4px 8px;
        margin: 2px;
        border-radius: 4px;
        color: @fg-color;
        background-color: #16161e;
        border: 1px solid @accent;
        font-size: 13px;
      }

      label.match {
        color: @fg-color;
        padding: 2px 6px;
        margin: 0;
      }

      label.match.description {
        font-size: 9px;
        color: #7aa2f7;
        margin: 0;
        padding: 0;
      }

      box.plugin {
        padding: 3px;
        margin: 1px 0;
      }

      box.plugin.info {
        min-width: 120px;
      }

      list.plugin {
        padding: 0;
        margin: 0;
      }

      .match {
        padding: 3px 6px;
        margin: 0;
      }

      .match:selected {
        border-left: 2px solid @accent;
        background: rgba(122, 162, 247, 0.2);
        padding-left: 4px;
      }

      .match:hover {
        background: rgba(122, 162, 247, 0.1);
      }
    '';

    extraConfigFiles."nixos-options.ron".text = let
      nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
      hm-options = inputs.home-manager.packages.${system}.docs-json + "/share/doc/home-manager/options.json";

      options = builtins.toJSON {
        ":nix" = [nixos-options];
        ":hm" = [hm-options];
        ":nall" = [nixos-options hm-options];
      };
    in ''
      Config(
          options: ${options},
          max_entries: Some(10)
      )
    '';
  };
}
