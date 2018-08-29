
[ -n "$__SHLIB_INCLUDED_ws_main_sh__" ] && return || readonly __SHLIB_INCLUDED_ws_main_sh__=1

. "$WS_HOME/shlib/shell.sh"

. "$WS_HOME/shlib/ws/globals.sh"
. "$WS_HOME/shlib/ws/command.sh"


_ws_main_setuplogs() {

    log_setmode "$wsconfig_log_mode"
    log_setlevel "$wsconfig_log_level"
    log_setfile "$wsconfig_log_file"
}

ws_main() (

    readonly wsrun_pid="$$"
    readonly wsrun_pwd="$(pwd -P)"

    wsconfig_verbose=$NO
    wsconfig_log_mode="$WS_LOG_MODE"
    wsconfig_log_file="$WS_LOG_FILE"
    wsconfig_log_level="$WS_LOG_LEVEL"

    wsconfig_at="$WS_AT"

    wsconfig_uid="$WS_USER_ID"
    wsconfig_uname="WS_USER_NAME"
    wsconfig_gid="$WS_GROUP_ID"
    wsconfig_gname="$WS_GROUP_NAME"

    wsconfig_user_home="$WS_USER_HOME"
    wsconfig_user_setupscript="$WS_USER_SETUP_SCRIPT"
    wsconfig_user_shell="$WS_USER_SHELL"

    wsconfig_workspaces_home="$WS_WORKSPACES_HOME"

    wsconfig_os_id="$WS_OS_ID"
    wsconfig_os_version="$WS_OS_VERSION"
    wsconfig_os_codename="$WS_OS_CODENAME"


    # ---

    local __parsing=$YES

    _ws_main_setuplogs

    while [ "$#" -ne 0 ] && is_true "$__parsing"; do
        case "$1" in
        -h|--help) shift; ws_command_help ;;

        --log-mode)   shift; wsconfig_log_mode="$1"; shift ;;
        --log-mode=*) wsconfig_log_mode="${1#*=}"; shift ;;

        --log|--log-level)     shift; wsconfig_log_level="$1"; shift ;;
        --log=*|--log-level=*) wsconfig_log_level="${1#*=}"; shift ;;

        --log-file)   shift; wsconfig_log_file="$1"; shift ;;
        --log-file=*) wsconfig_log_file="${1#*=}"; shift ;;

        # ---

        --) shift; __parsing=$NO ;;
        -*) die "Unknown option '$1'." ;;
        *)  __parsing=$NO ;;
        esac
    done

    _ws_main_setuplogs
)
