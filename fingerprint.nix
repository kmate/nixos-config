{pkgs, ...}: {
  # libfprint needs some patch, see https://gist.github.com/rmtsrc/80e41c9c6e23c765142f0d6d1a9817d8
  nixpkgs.overlays = [
    (_: prev: {
      libfprint = prev.libfprint.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ./libfprint-cleanup-existing.patch
          ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    fprintd
    fprintd-tod
  ];

  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
  };
}
