{pkgs,...}:
{
    programs.dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/Hephaestus";
        logs = {
            save = true;
            path = "/tmp/dms-greeter.log";
        };
    };
}
