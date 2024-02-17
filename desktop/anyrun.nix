{
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        inputs.anyrun.packages.${system}.applications
        # ./some_plugin.so
        # "${inputs.anyrun.packages.${system}.anyrun-with-all-plugins}/lib/kidex"
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

    #extraConfigFiles."some-plugin.ron".text = ''
    #  Config(
    #    // for any other plugin
    #    // this file will be put in ~/.config/anyrun/some-plugin.ron
    #    // refer to docs of xdg.configFile for available options
    #  )
    #'';
  };
}
