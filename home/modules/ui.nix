{ theme, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = theme.cursor.package;
    name = theme.cursor.name;
    size = theme.cursor.size;
    dotIcons.enable = true;
  };
}
