{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    virtualbox = {
      host.enable = true;
      guest.enable = true;
    };
  };

  users.extraGroups = {
    vboxusers.members = ["km"];
    docker.members = ["km"];
  };
}
