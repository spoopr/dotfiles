{
  colors,
  ...
}: {
    services.displayManager.ly = {
        enable = true;
        settings = {
            # copied this straight from the ly repo
            #
            # Ly supports 24-bit true color with styling, which means each
            # color is a 32-bit value. The format is 0xSSRRGGBB, where SS is
            # the styling, RR is red, GG is green, and BB is blue. Here are the
            # possible styling options:
            # TB_BOLD      0x01000000
            # TB_UNDERLINE 0x02000000
            # TB_REVERSE   0x04000000
            # TB_ITALIC    0x08000000
            # TB_BLINK     0x10000000
            # TB_HI_BLACK  0x20000000
            # TB_BRIGHT    0x40000000
            # TB_DIM       0x80000000
            # Programmatically, you'd apply them using the bitwise OR operator
            # (|), but because Ly's configuration doesn't support using it, you
            # have to manually compute the color value. Note that, if you want
            # to use the default color value of the terminal, you can use the
            # special value 0x00000000. This means that, if you want to use
            # black, you *must* use the styling option TB_HI_BLACK (the RGB
            # values are ignored when using this option).
            #
            # If full color is off, the styling options still work. The colors
            # are always 32-bit values with the styling in the most significant
            # byte. Note: If using the dur_file animation option and the dur
            # file's color range is saved as 256 with this option disabled, the
            # file will not be drawn.


            allow_empty_password = true;
            asterisk = "*";
            auth_fails = 0;
            clear_password = true;
            default_input = "password";


            # input box
            box_title = null;
            blank_box = true;
            bg = "0x00" + colors.black.hexNoHash;
            border_fg = "0x00" + colors.white.hexNoHash;
            fg = "0x00" + colors.white.hexNoHash;
            error_bg = "0x" + colors.black.hexNoHash;
            error_fg = "0x01" + colors.red.hexNoHash;
            margin_box_h = 3;
            margin_box_v = 1;
            hide_borders = false;

            animation_timeout_sec = 0;
            animation = "colormix";
            colormix_col1 = "0x00" + colors.lavendar.hexNoHash;
            colormix_col2 = "0x00" + colors.white.hexNoHash;
            colormix_col3 = "0x00" + colors.white.hexNoHash;

            full_color = true;
            battery_id = null;
            clock = null;
            edge_margin = 1;
            input_len = 34;
            hide_key_hints = true;
            hide_keyboard_locks = false;
            hide_version_string = true;
            lang = "en";
            min_refresh_delta = 5;
            text_in_center = false;

            vi_mode = true;

            initial_info_text = null;
            hibernate_cmd = null;
            inactivity_cmd = null;
            inactivity_delay = 0;
            login_cmd = null;


            login_defs_path = "/etc/login.defs";
            ly_log = "/var/log/ly.log";
            xinitrc = null;
        };
    };
}

