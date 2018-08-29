
[ -n "$__SHLIB_INCLUDED_shell_log_sh__" ] && return || readonly __SHLIB_INCLUDED_shell_log_sh__=1

. "$WS_HOME/shlib/shell/console.sh"

#
# [[ LOGGING: VARIABLES ]]
#

readonly LOG_TRACE=10
readonly LOG_DEBUG=20
readonly LOG_INFO=50
readonly LOG_WARN=70
readonly LOG_ERROR=90
readonly LOG_FATAL=100

log_setmode() {
    if [ "$1" = "simple" ]; then
        log() { log_simple "$@"; }
    elif [ "$1" = "long" ]; then
        log() { log_long "$@"; }
    else
        echo "* ERROR: Wrong logging type '$1'." >&2
        exit 1
    fi
}

log_setlevel() {
    LOG_LEVEL="$1"; shift
}

log_setfile() {
    STDLOG="$1"; shift
}

if ! typeof "log" >/dev/null; then
    log_setmode "${LOG_MODE:-"simple"}"
elif [ ! -z"$LOG_MODE" ]; then
    echo "* WARN: \$LOG_MODE is set to '$LOG_MODE', but `log` is already defined." >&2
else
    ! is_runnable "log" && echo "* ERROR: 'log' is not runnable." >&2 && exit 1
fi

trace() { log "$LOG_TRACE" "$@"; }
debug() { log "$LOG_DEBUG" "$@"; }
info() { log "$LOG_INFO" "$@"; }
warn() { log "$LOG_WARN" "$@"; }
error() { log "$LOG_ERROR" "$@"; }
fatal() { log "$LOG_FATAL" "$@"; }

# TODO Background colors (0;4x, 1;4x)

if [ ! -z "$LOG_NOCOLOR" ]; then
    log_color() { printf ""; }
else
    log_color() { color "$@"; }
fi

log_setlv() {
    case "$1" in
    t|T|trace|TRACE) LOG_LEVEL="$LOG_TRACE" ;;
    d|D|debug|DEBUG) LOG_LEVEL="$LOG_DEBUG" ;;
    i|I|info|INFO) LOG_LEVEL="$LOG_INFO" ;;
    w|W|warn|WARN) LOG_LEVEL="$LOG_WARN" ;;
    e|E|error|ERROR) LOG_LEVEL="$LOG_ERROR" ;;
    f|F|fatal|FATAL) LOG_LEVEL="$LOG_FATAL" ;;
    *)
        if [ ! -z "$1" ] && printf "%s" "$1" | grep '^[[:digit:]]*$'; then
            LOG_LEVEL="$1"
        else
            echo "* ERROR: Invalid log level '$1'." >&2
            exit 1
        fi
    esac
}

log_lvtoname() {
    local lv="$1"; shift
    case "$lv" in
    TRACE|DEBUG|INFO|WARN|ERROR)
        echo "$lv"
        ;;
    *)
        if [ "$lv" -le "$LOG_TRACE" ]; then echo "TRACE"
        elif [ "$lv" -le "$LOG_DEBUG" ]; then echo "DEBUG"
        elif [ "$lv" -le "$LOG_INFO" ]; then echo "INFO"
        elif [ "$lv" -le "$LOG_WARN" ]; then echo "WARN"
        elif [ "$lv" -le "$LOG_ERROR" ]; then echo "ERROR"
        else echo "FATAL"
        fi
        ;;
    esac
}

log_lvcolor() {
    local lv="$1"; shift
    if [ "$lv" -le "$LOG_TRACE" ]; then log_color "$LOG_COLOR_TRACE"
    elif [ "$lv" -le "$LOG_DEBUG" ]; then log_color "$LOG_COLOR_DEBUG"
    elif [ "$lv" -le "$LOG_INFO" ]; then log_color "$LOG_COLOR_INFO"
    elif [ "$lv" -le "$LOG_WARN" ]; then log_color "$LOG_COLOR_WARN"
    elif [ "$lv" -le "$LOG_ERROR" ]; then log_color "$LOG_COLOR_ERROR"
    else log_color "$LOG_COLOR_FATAL"
    fi
}

is_loggable_lv() { [ "$1" -ge "$LOG_LEVEL" ]; }
log_getwhen() { date -u -Ins; }
log_getwhere() { hostname; }
log_getpid() { echo $$; }
log_getsubject() { printf "%s\n" "$(basename "$0")"; }

log_simple() {
    local lv
    local msg
    local tpl
    lv="$1"; shift
    ! is_loggable_lv "$lv" && return
    if [ "$#" -gt 0 ]; then
        tpl="$1"; shift;
        printf "$tpl" "$@" | read msg
        [ "$?" -ne 0 ] && msg="$tpl"
    fi
    log_write_simple "$lv" "$msg"
}

log_write_simple() {
    local lv; lv="$1"; shift
    local msg; msg="$1"; shift
    lprintln "*** $(log_lvcolor "$lv")$(log_lvtoname "$lv")$(log_color): $msg"
}

log_long() {
    local lv
    local when
    local where
    local pid
    local subject
    local msg
    local tpl
    local line
    lv="$1"; shift
    ! is_loggable_lv "$lv" && return
    when="$(log_getwhen)"
    where="$(log_getwhere)"
    pid="$(log_getpid)"
    proc="$(log_getsubject)"
    if [ "$#" -gt 0 ]; then
        tpl="$1"; shift;
        printf "$tpl" "$@" | read msg
        [ "$?" -ne 0 ] && msg="$tpl"
    fi
    log_write_long "$lv" "$when" "$where" "$pid" "$subject" "$msg"
}

log_write_long() {
    local lv; lv="$1"; shift
    local lvtext; lvtext="$(printf "[% 5s:%03d]" "$(log_lvtoname "$lv")" "$lv")"
    local when; when="$1"; shift
    local where; where="$1"; shift
    local pid; pid="$1"; shift
    local subject; subject="$1"; shift
    local msg; msg="$1"; shift
    lprintln "$LOG_FORMAT" "$(log_lvcolor "$lv")$lvtext$(log_color)" "$when" "$where" "$pid" "$subject" "$msg"
}
