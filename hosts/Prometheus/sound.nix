{ pkgs, ... }:

let
  # The TAS2781 amplifiers are attached to this Meteor Lake DesignWare I2C
  # controller. Keep the identity checks beside the service that removes and
  # re-enumerates it so a future hardware change fails safely.
  tas2781Controller = "0000:00:15.2";
  tas2781Vendor = "0x8086";
  tas2781Device = "0x7e7a";

  initialiseTas2781 = pkgs.writeShellScript "initialise-tas2781" ''
    set -euo pipefail

    controller=/sys/bus/pci/devices/${tas2781Controller}
    i2c_device=/sys/bus/i2c/devices/i2c-TIAS2781:00

    read -r actual_vendor < "$controller/vendor"
    read -r actual_device < "$controller/device"

    if [[ "$actual_vendor" != "${tas2781Vendor}" || "$actual_device" != "${tas2781Device}" ]]; then
      printf 'Refusing to reset unexpected PCI device %s (%s:%s)\n' \
        "${tas2781Controller}" "$actual_vendor" "$actual_device" >&2
      exit 1
    fi

    # The firmware can fail to load against the amplifier state left by the
    # BIOS. Removing the parent controller lets ACPI power-cycle the bus before
    # the native TAS2781 driver probes it again.
    printf 'Resetting TAS2781 I2C controller %s\n' "${tas2781Controller}"
    printf '1\n' > "$controller/remove"
    sleep 2
    printf '1\n' > /sys/bus/pci/rescan
    udevadm settle --timeout=10

    if [[ ! -e "$controller" || ! -e "$i2c_device" ]]; then
      printf 'TAS2781 I2C controller did not re-enumerate\n' >&2
      exit 1
    fi

    modprobe snd_hda_scodec_tas2781_i2c
    sleep 5

    if [[ ! -L "$i2c_device/driver" ]]; then
      printf 'Native TAS2781 driver did not bind\n' >&2
      exit 1
    fi

    # The driver otherwise trusts the DSP state cached during probe. On this
    # machine that leaves the woofers silent after every playback open. Keep
    # the driver's supported reload control enabled so each new stream loads
    # the TI program and configuration while retaining normal HDA volume.
    force_firmware_control="iface=CARD,name=Speaker Force Firmware Load"
    for ((attempt = 1; attempt <= 10; attempt++)); do
      if amixer --card sofhdadsp cget "$force_firmware_control" >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    if ((attempt > 10)); then
      printf 'TAS2781 firmware reload control did not appear\n' >&2
      exit 1
    fi

    amixer --card sofhdadsp cset "$force_firmware_control" on >/dev/null
  '';
in
{
  systemd.services.tas2781-native-init = {
    description = "Reset, bind, and arm the native TAS2781 speaker driver";

    wantedBy = [ "multi-user.target" ];
    after = [
      "sound.target"
      "systemd-udevd.service"
    ];
    before = [ "display-manager.service" ];

    unitConfig.ConditionPathExists = "/sys/bus/pci/devices/${tas2781Controller}/remove";

    path = with pkgs; [
      alsa-utils
      coreutils
      kmod
      systemd
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = initialiseTas2781;
      RemainAfterExit = true;
    };
  };

  # Runtime-suspending this controller can put it into D3cold and erase the
  # volatile TAS2781 firmware state. Apply the rule on both add and bind because
  # i2c_designware may restore automatic power management while binding.
  services.udev.extraRules = ''
    ACTION=="add|bind", SUBSYSTEM=="pci", KERNEL=="${tas2781Controller}", ATTR{vendor}=="${tas2781Vendor}", ATTR{device}=="${tas2781Device}", ATTR{power/control}="on"
  '';
}
