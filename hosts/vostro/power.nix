{
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_SCALING_MIN_FREQ_ON_AC = 400000;
      CPU_SCALING_MAX_FREQ_ON_AC = 4200000;
      START_CHARGE_THRESH_BAT0 = 95;
      STOP_CHARGE_THRESH_BAT0 = 100;
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
  };

  systemd.targets = {
    sleep.enable = true;
    suspend.enable = true;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
