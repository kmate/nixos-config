{
  inputs,
  system,
  osConfig,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${system}.applications
        inputs.anyrun-nixos-options.packages.${system}.default
        "${inputs.anyrun.packages.${system}.anyrun-with-all-plugins}/lib/libkidex.so"
        "${inputs.anyrun.packages.${system}.anyrun-with-all-plugins}/lib/librandr.so"
        "${inputs.anyrun.packages.${system}.anyrun-with-all-plugins}/lib/librink.so"
        "${inputs.anyrun.packages.${system}.anyrun-with-all-plugins}/lib/libsymbols.so"
      ];
      width = {fraction = 0.3;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };
    #extraCss = ''
    #  .some_class {
    #    background: red;
    #  }
    #'';

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
