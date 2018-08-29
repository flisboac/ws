
[ -n "$__SHLIB_INCLUDED_shell_globals_sh__" ] && return || readonly __SHLIB_INCLUDED_shell_globals_sh__=0

OS_ID="${OS_ID:-"$([ -r /etc/os-release ] && . /etc/os-release && printf '%s\n' "$ID")"}"
OS_ID="${OS_ID:-"$(command -v lsb_release >/dev/null && lsb_release -si)"}"
OS_ID="${OS_ID:?"Could not determine 'OS_ID'."}"

OS_VERSION="${OS_VERSION:-"$([ -r /etc/os-release ] && . /etc/os-release && printf '%s\n' "$VERSION_ID")"}"
OS_VERSION="${OS_VERSION:-"$(command -v lsb_release >/dev/null && lsb_release -sr)"}"
OS_VERSION="${OS_VERSION:?"Could not determine 'OS_VERSION'."}"

OS_CODENAME="${OS_CODENAME:-"$([ -r /etc/os-release ] && . /etc/os-release && printf '%s\n' "$VERSION_CODENAME")"}"
OS_CODENAME="${OS_CODENAME:-"$(command -v lsb_release >/dev/null && lsb_release -sc)"}"
OS_CODENAME="${OS_CODENAME:?"Could not determine 'OS_CODENAME'."}"
