{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      ale
      nerdtree
      nerdtree-git-plugin
    ];
  };
}
