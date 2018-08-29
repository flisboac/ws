
[ -n "$__SHLIB_INCLUDED_ws_globals_sh__" ] && return || readonly __SHLIB_INCLUDED_ws_globals_sh__=1

. "$WS_HOME/shlib/shell/globals.sh"

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

WS_USER_NAME="${WS_USER_NAME:-"$(id -u)"}"
WS_USER_ID="${WS_USER_ID:-"$(id -n)"}"
WS_USER_HOME="${WS_USER_HOME:-"$HOME"}"
WS_USER_SETUP_SCRIPT="${WS_USER_SETUP_SCRIPT:-"$WS_USER_HOME/.profile-setup"}"
WS_USER_SHELL="${WS_USER_SHELL:-${SHELL:-"/bin/sh"}}"
WS_GROUP_NAME="${WS_GROUP_NAME:-$WS_USER_NAME}"
WS_GROUP_ID="${WS_GROUP_NAME:-$WS_USER_ID}"
WS_USER_HOME="${WS_USER_HOME:-"$HOME"}"

WS_WORKSPACES_DIRNAME="${WS_WORKSPACES_DIRNAME:-"workspaces"}"
WS_WORKSPACES_HOME="${WS_WORKSPACE_HOME:-"$WS_USER_HOME/$WS_WORKSPACES_DIRNAME"}"

WS_OS_ID="${OS_ID:?"Could not determine 'WS_OS_ID'."}"
WS_OS_VERSION="${OS_VERSION:?"Could not determine 'WS_OS_VERSION'."}"
WS_OS_CODENAME="${OS_CODENAME:?"Could not determine 'WS_OS_CODENAME'."}"

# Space-separated variables that will never be cached
WS_VARS_BLACKLIST="${WS_VARS_BLACKLIST}"
