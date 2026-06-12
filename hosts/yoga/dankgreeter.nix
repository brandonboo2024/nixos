{pkgs,...}:
{
    programs.dank-material-shell.greeter = {
        enable = true;
        compositor.name = "mango";
        configHome = "/home/Prometheus";
        compositor.customConfig = ''
            monitorrule=name:eDP-1,width:3200,height:2000,refresh:165,x:0,y:0,scale:1.5
        '';
        logs = {
            save = true;
            path = "/tmp/dms-greeter.log";
        };
    };
}
