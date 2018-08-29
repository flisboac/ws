
[ -n "$__SHLIB_INCLUDED_shell_console_sh__" ] && return || readonly __SHLIB_INCLUDED_shell_console_sh__=0


#
# [[ SHELL TYPE DETECTION ]]
#

current_shell() {
    ps -p $$ -ocomm= 2>/dev/null
}

typeof_shell() {
    local shell_name
    [ ! -z "$BASH" ] && echo "bash" && return
    [ ! -z "$ZSH_NAME" ] && echo "zsh" && return
    shell_name="$(basename "$(current_shell)" 2>/dev/null)"
    [ ! -z "$shell_name" ] && printf "%s\n" "$shell_name" && return
    # May never reach here
    echo "sh"
}

set_posix() {
    case "$(typeof_shell)" in
    bash) set -o posix ;;
    esac
}

unset_posix() {
    case "$(typeof_shell)" in
    bash) set +o posix ;;
    esac
}


#
# [[ (LOW-LEVEL) SHELL UTILITIES ]]
#


readonly YES=0
readonly NO=1

[ -z "$SHELL_HAS_TYPE_T" ] && SHELL_HAS_TYPE_T="$(type -t 'if' 2>/dev/null >/dev/null; echo "$?")"
[ -z "$SHELL_HAS_READ_S" ] && SHELL_HAS_READ_S="$(echo "\n" | read -s 'if' 2>/dev/null >/dev/null; echo "$?")"


typeof() {
	local elem; elem="$1"; shift
	local typeinfo
	local typeid
	local exitcode

	if [ "$SHELL_HAS_TYPE_T" -eq 0 ]; then
        type -t "$elem"
        exitcode="$?"
    else
		typeinfo="$(LANG=C command -V "$elem" 2>/dev/null)"
		exitcode="$?"
		typeinfo="$(echo "$typeinfo" | sed 's/^.*is //')"
		if [ "$exitcode" -eq 0 ]; then
			if ( echo "$typeinfo" | grep "a shell keyword" >/dev/null ); then echo "keyword"
			elif ( echo "$typeinfo" | grep "a shell function" >/dev/null ); then echo "function"
			elif ( echo "$typeinfo" | grep "is an alias for" >/dev/null ); then echo "alias"
			elif ( echo "$typeinfo" | grep "a shell builtin" >/dev/null ); then echo "builtin"
			else echo "file"
			fi
		fi
	fi

    if [ "$exitcode" -ne 0 ]; then
        if is_var "$elem"; then
            echo "var"
            exitcode=0
        fi
    fi

    return "$exitcode"
}

is_var() {
    (
        set_posix
        set | grep "^$1=" >/dev/null 2>/dev/null
    )
}

is_true() {
    return "$(test "$1" -eq 0; echo "$?")"
}

is_false() {
    return "$(test "$1" -ne 0; echo "$?")"
}

is_success() {
    is_true "${1:-"$?"}"
}

is_failure() {
    is_false "${1:-"$?"}"
}

exitof() {
    local exitcode
    "$@" >/dev/null 2>/dev/null
    exitcode="$?"
    echo "$exitcode"
    return "$exitcode"
}

is_function() {
    [ "$(typeof "$1")" = "function" ] && return $YES
    return $NO
}

is_alias() {
    [ "$(typeof "$1")" = "alias" ] && return $YES
    return $NO
}

is_executable() {
    [ -x "$(command -v "$1")" ] && return $YES
    return $NO
}

# For all intents and purposes, this function consider an alias to contain an
# executable or part of a valid command.
is_runnable() {
    if is_function "$1" || is_alias "$1" || is_executable "$1"; then
        return $YES
    fi
    return $NO
}

to_VARNAME() {
	local env_name; env_name="$(to_varname "$@")"
	[ "$?" -ne 0 ] && return "$?"
	printf "%s\n" "$env_name" | tr '[:lower:]' '[:upper:]'
}

to_varname() {
	local opt_suffix=""
	[ "$#" -eq 0 ] && return 1
	local name; name="$1"; shift
	[ "$#" -gt 0 ] && opt_suffix="$1" && shift
	local tr_name; tr_name="$(printf "%s" "$name" | tr '(\s\t|[:punct:])' '_' | tr -d '[:space:]')"
	[ ! -z "$tr_name" ] && tr_name="$tr_name$opt_suffix"
	printf "%s\n" "$tr_name"
}

read_password() {
	local var; var="$1"; shift
	local msg
	local cmd
	if [ "$#" -gt 0 ]; then
		msg="$1"; shift
		cmd="-p \"$msg\" \"$var\""
	else
		cmd="\"$var\""
	fi
	if [ "$SHELL_HAS_READ_S" -eq 0 ]; then
		eval "read -s $cmd"
	else
		stty -echo
		eval "read $cmd"
		printf \\n
		stty echo
	fi
}


#
# [[ CONSOLE OUTPUT ]]
#

readonly EXIT_SUCCESS=0
EXIT_FAILURE="${EXIT_FAILURE:-1}"

[ -z "$C_BLACK"   ] && C_BLACK='0;30'
[ -z "$C_GRAY"    ] && C_GRAY='1;30'
[ -z "$C_LGRAY"   ] && C_LGRAY='0;37'
[ -z "$C_WHITE"   ] && C_WHITE='1;37'
[ -z "$C_RED"     ] && C_RED='1;31'
[ -z "$C_LRED"    ] && C_LRED='0;31'
[ -z "$C_GREEN"   ] && C_GREEN='1;32'
[ -z "$C_LGREEN"  ] && C_LGREEN='0;32'
[ -z "$C_ORANGE"  ] && C_ORANGE='1;33'
[ -z "$C_YELLOW"  ] && C_YELLOW='0;33'
[ -z "$C_BLUE"    ] && C_BLUE='1;34'
[ -z "$C_LBLUE"   ] && C_LBLUE='0;34'
[ -z "$C_PURPLE"  ] && C_PURPLE='1;35'
[ -z "$C_LPURPLE" ] && C_LPURPLE='0;35'
[ -z "$C_CYAN"    ] && C_CYAN='1;36'
[ -z "$C_LCYAN"   ] && C_LCYAN='0;36'
[ -z "$C_NOCOLOR" ] && C_NOCOLOR='0' # No Color

[ -z "$STDOUT" ] && STDOUT="-"
[ -z "$STDERR" ] && STDERR="-"
[ -z "$STDLOG" ] && STDLOG="-"

# TODO Background colors (0;4x, 1;4x)


color() {
    local IFS=";"
    [ "$#" -eq 0 ] && set -- $C_NOCOLOR
    printf "\033[$*m"
}


#
# Prints to STDOUT
#
print() {
    local __file
    local IFS
    IFS=":"
    for __file in $STDOUT; do
        if [ "$__file" = "-" ]; then
            printf "$@" >&1
        elif printf "%s\n" "$__file" | grep '^[[:digit:]]*$'; then
            printf "$@" >&"$__file"
        else
            printf "$@" >"$__file"
        fi
    done
}

println() {
    local fmt; fmt="$1\n"; shift;
    print "$fmt" "$@"
}

#
# Prints to STDLOG (Default output for logging)
#
lprint() {
    local __file
    local IFS
    IFS=":"
    for __file in $STDLOG; do
        if [ "$__file" = "-" ]; then
            printf "$@" >&2
        elif printf "%s\n" "$__file" | grep '^[[:digit:]]*$'; then
            printf "$@" >&"$__file"
        else
            printf "$@" >"$__file"
        fi
    done
}

lprintln() {
    local fmt; fmt="$1\n"; shift;
    lprint "$fmt" "$@"
}

#
# Prints to STDERR
#
eprint() {
    local __file
    local IFS
    IFS=":"
    for __file in $STDERR; do
        if [ -z "$__file" ]; then
            printf "$@" >&2
        elif printf "%s\n" "$__file" | grep '^[[:digit:]]*$'; then
            printf "$@" >&"$__file"
        else
            printf "$@" >"$__file"
        fi
    done
}

eprintln() {
    local fmt; fmt="$1\n"; shift;
    eprint "$fmt" "$@"
}


abort() {
    local exitcode; exitcode="$1"; shift
    if [ "$#" -gt 0 ]; then
        if [ "$exitcode" -eq 0 ]; then
            "${EXIT_LOGOK:-"${LOG_EXITFN_OK:-lprintln}"}" "$@"
        else
            "${EXIT_LOGNOK:-"${LOG_EXITFN_NOK:-eprintln}"}" "$@"
        fi
    fi
    exit "$exitcode"
}

bye() {
    abort "$EXIT_SUCCESS" "$@"
}

die() {
    local __exitcode="$?"
    if [ "$__exitcode" -ne 0 ]; then
        abort "$__exitcode" "$@"
    else
        abort "$EXIT_FAILURE" "$@"
    fi
}
