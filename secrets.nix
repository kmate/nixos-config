{...}: {
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persist/age/keys.txt";

    secrets."network-manager.env" = {};
    secrets."passwords.km" = {
      neededForUsers = true;
    };
  };
}
