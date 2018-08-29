
[ -n "$__SHLIB_INCLUDED_ws_globals_sh__" ] && return || readonly __SHLIB_INCLUDED_ws_globals_sh__=0

. "$WS_HOME/shlib/shell/globals.sh"

readonly WS_VERSION_MAJOR="0"
readonly WS_VERSION_MINOR="1"
readonly WS_VERSION_PATCH="0"
readonly WS_VERSION_IDENT=""
readonly WS_VERSION="\
${WS_VERSION_MAJOR}\
.${WS_VERSION_MINOR}\
.${WS_VERSION_PATCH}\
${WS_VERSION_IDENT:+"-$WS_VERSION_IDENT"}"

readonly WS_AT_HOST="host"
readonly WS_AT_GUEST="guest"

# Space-separated variables that `ws` will always modify.
# 
readonly WS_VARS_MANAGED="PATH"

[ -r "$WS_HOME/etc/ws.conf" ] && [ -f "$WS_HOME/etc/ws.conf" ] && . "$WS_HOME/etc/ws.conf"
[ -r /etc/ws.conf ] && [ -f /etc/ws.conf ] && . /etc/ws.conf
[ -r ~/.config/ws.conf ] && [ -f ~/.config/ws.conf ] && . ~/.config/ws.conf

WS_AT="${WS_AT:-"$WS_AT_HOST"}"

WS_VERBOSE="${WS_VERBOSE:-1}"
WS_LOG_MODE="${WS_LOG_MODE:-"simple"}"
WS_LOG_FILE="$${WS_LOG_FILE:-"-"}"
WS_LOG_LEVEL="${WS_LOG_LEVEL:-"info"}"

WS_UNAME="${WS_UNAME:-"$(id -u)"}"
WS_UID="${WS_UID:-"$(id -n)"}"
WS_UHOME="${WS_UHOME:-"$HOME"}"
WS_SHELL="${WS_SHELL:-${SHELL:-"/bin/sh"}}"
WS_GNAME="${WS_GNAME:-$WS_UNAME}"
WS_GID="${WS_GNAME:-$WS_UID}"
WS_UHOME="${WS_UHOME:-"$HOME"}"

WS_WORKSPACES_DIRNAME="${WS_WORKSPACES_DIRNAME:-"workspaces"}"
WS_WORKSPACES_HOME="${WS_WORKSPACE_HOME:-"$WS_UHOME/$WS_WORKSPACES_DIRNAME"}"

WS_OS_ID="${OS_ID:?"Could not determine 'WS_OS_ID'."}"
WS_OS_VERSION="${OS_VERSION:?"Could not determine 'WS_OS_VERSION'."}"
WS_OS_CODENAME="${OS_CODENAME:?"Could not determine 'WS_OS_CODENAME'."}"
