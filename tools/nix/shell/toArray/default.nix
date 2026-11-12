{
    ...
}: {
    flake.lib.shell.toArray = list: list
        |> builtins.concatStringsSep "\" \""
        # the extra spaces between the opening and closing parenthesis (see
        # below) are for the sake of regex pattern matching on the bash array
        #
        # here:
        #        v        v
        |> (x: "( \"${x}\" )");
}
