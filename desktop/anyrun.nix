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
      width = {fraction = 0.3;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };
    extraCss = ''
      window {
        background: rgba(0, 0, 0, 0.3);
      }

      #entry {
        background-color: #1F2231;
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
