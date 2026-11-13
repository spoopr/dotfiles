{
  pkgs,
  ...
}: {
    dotfiles = {
        user.niri.enable = true;
    };

    environment.systemPackages = [
        (pkgs.mullvad-browser.overrideAttrs {
            postBuild = ''
                # this postBuild is a custom extension of the
                # `nixpkgs#mullvad-browser` package; see the original for
                # implementation details
                cat >>mozilla.cfg << EOF
                // use blank pages for homepage and newtab pages
                pref("browser.startup.homepage", "chrome://browser/content/blanktab.html")
                pref("browser.newtabpage.enabled", false)

                // hide the "using your system language" popup
                pref("intl.language_notification.shown", true)

                // use firefox darkmode
                pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org")
                EOF
                '';
        })
    ];
}
