{ pkgs }: {
  deps = [
    pkgs.netcat-gnu
    pkgs.netcat.nc
    pkgs.nim
    pkgs.bashInteractive
    pkgs.nodePackages.bash-language-server
    pkgs.man
  ];
}