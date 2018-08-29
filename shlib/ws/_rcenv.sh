

ws_rcenv_preload() {

    [ -n "$wsrun_loadenv_rc" ] && return || readonly wsrun_loadenv_rc=0

    readonly wsrun_pid="$$"
    readonly wsrun_pwd="$(pwd -P)"

    # ---
    
    wsconfig_verbose="${wsconfig_verbose:-$NO}"
    wsconfig_log_mode="${wsconfig_log_mode:-"$WS_LOG_MODE"}"
    wsconfig_log_file="${wsconfig_log_file:-"$WS_LOG_FILE"}"
    wsconfig_log_level="${wsconfig_log_level:-"$WS_LOG_LEVEL"}"

    wsconfig_at="${wsconfig_at:-"$WS_AT"}"

    wsconfig_uid="${wsconfig_uid:-"$WS_UID"}"
    wsconfig_uname="${wsconfig_uname:-"$WS_UNAME"}"
    wsconfig_gid="${wsconfig_gid:-"$WS_GID"}"
    wsconfig_gname="${wsconfig_gname:-"$WS_GNAME"}"
    wsconfig_uhome="${wsconfig_uhome:-"$WS_UHOME"}"
    wsconfig_shell="${wsconfig_shell:-"$WS_SHELL"}"

    wsconfig_user_home="${wsconfig_user_home:-"$wsconfig_uhome/.local/share/ws"}"
    wsconfig_user_confighome="${wsconfig_user_confighome:-"$wsconfig_uhome/.config/ws"}"
    wsconfig_user_setupscript="${wsconfig_user_setupscript:-"$wsconfig_user_confighome/ws-setup.rc"}"

    wsconfig_state_home="${wsconfig_state_home:-"$wsconfig_user_home/.cache/ws"}"

    wsconfig_workspaces_home="${wsconfig_workspaces_home:-"$WS_WORKSPACES_HOME"}"

    wsconfig_os_id="${wsconfig_os_id:-"$WS_OS_ID"}"
    wsconfig_os_version="${wsconfig_os_version:-"$WS_OS_VERSION"}"
    wsconfig_os_codename="${wsconfig_os_codename:-"$WS_OS_CODENAME"}"

    # ---

    wsrun_commands=""

    # ---

    _ws_rcenv_setuplogs
}


ws_rcenv_load() {

    # TODO Load CONF/RC files from global (system) and user scopes, in that order.

    . "$WS_HOME/shlib/ws/_runtime/commands/help.sh"
    . "$WS_HOME/shlib/ws/_runtime/commands/init.sh"
    . "$WS_HOME/shlib/ws/_runtime/commands/list.sh"

    _ws_rcenv_setuplogs
    ws_rcenv_check
}

ws_rcenv_check() {
    # TODO Checks
    true
}

_ws_rcenv_setuplogs() {

    log_setmode "$wsconfig_log_mode"
    log_setlevel "$wsconfig_log_level"
    log_setfile "$wsconfig_log_file"
}
