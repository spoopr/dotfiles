{
  ...
}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        email = "spoopr@users.noreply.github.com";
        name = "spoopr";
      };
      init = { defaultBranch = "main"; };
    };
  };
}
