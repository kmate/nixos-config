{
  virtualisation = {
    containers.enable = true;

    oci-containers.backend = "podman";

    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # TODO: re-enable after https://github.com/NixOS/nixpkgs/pull/318330 gets merged
    #virtualbox = {
    #  host.enable = true;
    #  guest.enable = true;
    #};
  };

  #users.extraGroups = {
  #  vboxusers.members = ["km"];
  #};
}
