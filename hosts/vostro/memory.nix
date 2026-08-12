{ lib, ... }:

{
  # 8 GiB RAM with zero swap => the kernel OOM-killer fires during
  # compile/link steps and takes the session down. Three layers here:
  # compressed RAM swap, a real disk swapfile, and bounded build fan-out.

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # ~3.8 GiB of RAM backing ~10 GiB compressed
    priority = 100; # preferred over the disk swapfile
  };

  swapDevices = lib.mkForce [{
    device = "/var/lib/swapfile";
    size = 8 * 1024; # MiB
    priority = 10; # spillover once zram is saturated
  }];

  boot.kernel.sysctl = {
    # zram is cheap to page into, so lean on it early instead of letting
    # the working set grow until the OOM-killer has no choice.
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  # Bound peak build memory. 8 parallel nix jobs each spawning 8 compiler
  # processes is what actually exhausts RAM; 2 x 4 keeps the box usable.
  nix.settings = {
    max-jobs = 2;
    cores = 4;
  };

  # When pressure does spike, kill the offending cgroup deliberately rather
  # than letting the kernel OOM-killer pick a random victim (often the
  # compositor, which is what reads as a "PC crash").
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };
}
