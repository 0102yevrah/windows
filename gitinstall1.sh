#!/usr/bin/env bash

# Must be root
if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi

# Load OS info
. /etc/os-release

# -----------------------------
# Ubuntu: Add Git Core PPA
# -----------------------------
if [ "$ID" = "ubuntu" ]; then
    echo "Adding Git PPA for Ubuntu..."

    # Git Core PPA GPG key
    GIT_CORE_PPA_ARCHIVE_GPG_KEY=F911AB184317630C59970973E363C90F8F1B6217

    # Make sure gpg + curl exist (required to add repo)
    apt-get update
    apt-get install -y curl gnupg2 dirmngr ca-certificates

    # Import the PPA key
    export GNUPGHOME="/tmp/tmp-gnupg"
    mkdir -p "$GNUPGHOME"
    chmod 700 "$GNUPGHOME"
    echo "disable-ipv6" > "$GNUPGHOME/dirmngr.conf"
    gpg --no-default-keyring --keyring /usr/share/keyrings/gitcoreppa-archive-keyring.gpg --recv-keys "$GIT_CORE_PPA_ARCHIVE_GPG_KEY"

    # Add the repo
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gitcoreppa-archive-keyring.gpg] http://ppa.launchpad.net/git-core/ppa/ubuntu ${VERSION_CODENAME} main" \
        > /etc/apt/sources.list.d/git-core-ppa.list

    echo "Ubuntu Git PPA added."
fi

# -----------------------------
# Debian: Add default Debian repo
# -----------------------------
if [ "$ID" = "debian" ]; then
    echo "Adding default Debian repo..."

    # Create a clean sources.list with the official Debian repo
    echo "deb http://deb.debian.org/debian ${VERSION_CODENAME} main contrib non-free" \
        > /etc/apt/sources.list

    echo "Default Debian repo added."
    echo "Installing GIT + GH"
    apt install git
    apt install gh
fi

echo "Done."
