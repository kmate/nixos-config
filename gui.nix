{...}: {
  # TODO change to wayland and hyperland

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      options = "caps:escape";
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    videoDrivers = ["amdgpu"];
  };
}
