{ ... }:

{
    # https://nixos.wiki/wiki/Virt-manager

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
}
