

_ws_main_help() {

    eprintln "TODO Help implementation."
}

ws_main() (

    local __parsing=$YES

    ws_rcenv_preload

    while [ "$#" -ne 0 ] && is_true "$__parsing"; do
        case "$1" in
        -h|--help) shift; _ws_main_help ;;

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

    ws_rcenv_load
    ws_command_run "$@"
)
