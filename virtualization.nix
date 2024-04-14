{
  virtualisation = {
    virtualbox = {
      host.enable = true;
      guest = {
        enable = true;
        x11 = true;
      };
    };
  };
  users.extraGroups.vboxusers.members = ["km"];
}
