{theme, ...}:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    flavors = theme.yazi.flavors;
    theme = {
      flavor.use = theme.yazi.flavor;
    };
  };
}
