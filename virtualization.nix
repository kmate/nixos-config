{
  virtualisation = {
    virtualbox = {
      host.enable = true;
      guest = {
        enable = true;
      };
    };
  };
  users.extraGroups.vboxusers.members = ["km"];
}
