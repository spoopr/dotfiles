# thisll be appended to a larger file, so no shebang

#
# the nix file reading this sets $NIX_ENV as a way to access nix-env
# it also sets $shorts, an array, with the current configuration
# short hash
#

# only when switching, to avoid accidentally destroying a config
if [[ $NIXOS_ACTION =~ "switch" ]]; then   
    profile=/nix/var/nix/profiles/
    generations=($profile/*/)

    # sort for the generations using the proper label for this system
    targets=()
    for generation in "${generations[@]}"; do
        if [[ "$generation" =~ .*-link\/$ ]] && [[ $(cat "$generation/nixos-version") =~ ^[0-9a-f]{7} ]]; then
            targets+=("$generation")
        fi
    done
    unset generations

    # sort profiles
    IFS=$'\n'
    targets=($(sort -r <<< "${targets[*]}"))
    unset IFS

    # keep generations up to the first two unique short hashes 
    # plus 4, delete the rest
    extra=0
    removed=()
    for generation in "${targets[@]}"; do
        version=$(cat "$generation/nixos-version")

        if ! [[ "${shorts[@]}" =~ "${version::6}" ]]; then
            if [[ "${#shorts[@]}" == 2 ]]; then
                if [[ "$extra" == 4 ]]; then
                    removed+=("${generation//[!0-9]}")
                else
                    extra+=1
                fi
            else
                shorts+=("$version")
            fi
        fi
    done
    unset version targets extra

    echo "[autoremove] removing ${#removed[@]} generation$([[ ${#removed[@]} == 1 ]] || echo "s")"
    "$NIX_ENV" --profile $profile/system --delete-generations  "${removed[@]}"
    unset removed profile
fi

unset NIX_ENV shorts
