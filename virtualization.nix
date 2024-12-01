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

    #    virtualbox = {
    #      host.enable = true;
    #      guest.enable = true;
    #    };
  };

  users.extraGroups = {
    vboxusers.members = ["km"];
  };
}
