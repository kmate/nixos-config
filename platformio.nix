{pkgs, ...}: {
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];
}
