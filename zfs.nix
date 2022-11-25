{ config, pkgs, ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];
    # 1GB ARC
    kernelParams = [ "zfs.zfs_arc_max=1884901888" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    zfs.extraPools = [ "bpool" "rpool" ];
    loader = {
      efi =
        {
          efiSysMountPoint = "/boot/efi";
          canTouchEfiVariables = true;
        };
      generationsDir.copyKernels = true;
      grub =
        {
          enable = true;
          version = 2;
          copyKernels = true;
          efiSupport = true;
          zfsSupport = true;
          useOSProber = true;
          efiInstallAsRemovable = false;
          device = "nodev";
        };
    };
  };
  networking.hostId = "197fcb98";
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  users.users.root.initialHashedPassword = "$6$C4kNotB.keaoCb2J$XyPs4GEHcKr75sOvudnyFvPAICI.nlk47F4/tBocxQnWciV/ppmm1FT5icou4VVe0ceoUmaZ.y2RL20JTpqKq0";
}
