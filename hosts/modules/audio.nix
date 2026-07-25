{ ... }:

# PipeWire, replacing PulseAudio while keeping the ALSA and PulseAudio
# client-side interfaces so ordinary applications still work.
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
