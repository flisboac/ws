
[ -n "$__SHLIB_INCLUDED_shell_ospkg_sh__" ] && return || readonly __SHLIB_INCLUDED_shell_ospkg_sh__=0

. "$WS_HOME/shlib/shell/globals.sh"

ospkg_update() {
    apt-get update -y
}

ospkg_upgrade() {
    apt-get update -y \
        && apt-get upgrade -y
}

ospkg_pkginstall() {
    dpkg -i "$@" && apt-get install -y -f
}

ospkg_install() {
    apt-get install -y "$@"
}

