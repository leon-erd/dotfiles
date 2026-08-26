{ ... }:

{
  flake.modules.nixos.n8n =
    { ... }:

    {
      services.n8n = {
        enable = true;
        openFirewall = true;
        environment = {
          N8N_SECURE_COOKIE = false;
        };
      };
    };
}
