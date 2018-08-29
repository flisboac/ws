
ws_command_run() {

    local wsrun_command
    local wsrun_command_exec
    local wsrun_command_nargs

    local __iarg
    local __nargs
    local __runnables
    local wsrun_command_exitcode

    while [ "$#" -ne 0 ]; do
        wsrun_command="$1"; shift
        __nargs="$#"
        wsrun_command_nargs="$#"
        
        # Executing command
        __runnables="$(ws_command_listrunnables)"
        [ -z "$__runnables" ] && die "Command '$wsrun_command' is invalid or has no executable configured for it."

        for wsrun_command_exec in $__runnables; do
            ! is_runnable "$wsrun_command_exec" && die "Command '$wsrun_command' has non-runnable executable '$wsrun_command_exec'."

            ( "$wsrun_command_exec" "$@" )
            wsrun_command_exitcode="$?"

            if is_failure "$wsrun_command_exitcode"; then
                die "Command '$wsrun_command' failed with code '$wsrun_comand_exitcode'!"
            fi

            # Removing extra arguments
            __iarg="0"
            while [ "$__iarg" -lt "$wsrun_command_nargs" ] && [ "$#" -gt 0 ]; do
                __iarg="$((__iarg+1))"; shift
                if [ "$#" -eq 0 ]; then
                    warn "Command '$wsrun_command' informed a number of consumed arguments ($wsrun_command_nargs) greater than the amount available ($__nargs)."
                    break
                fi
            done
        done
    done
}


ws_command_exists() {

    ws_command_list | grep -E "$1" >/dev/null
}


ws_command_list() {

    _ws_command_list "wsconfig_commands"
}


ws_command_listrunnables() {

    _ws_command_listsub "wsconfig_command" "$@"
}


#
# [[ INTERNAL FUNCTIONS ]]
#


_ws_command_list() {

    local __command
    local __commands
    local __commands_var
    local __listname
    local IFS

    __listname="$1"; shift

    __commands_var="\$${__listname}"
    __commands="$(eval "$__commands_var")" || die "Error while evaluating variable '$__commands_var'."
    __commands="${__commands#;}"

    IFS=";"
    for __command in $__commands; do
        printf '%s\n' "$__command"
    done
}


_ws_command_listsub() {

    local __listname
    local __command

    __listname="$1"; shift

    if [ "$#" -gt 0 ]; then
        __command="$1"; shift
    else
        __command="${wsrun_command:?"Command name not provided."}"
    fi

    __listname="${__listname}_$(to_varname "$__command")"

    _ws_command_list "$__listname" "$@"
}
