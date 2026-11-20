#!/bin/sh
set -eu

# Arresta le istanze Samba; non rimuove il pacchetto Entware
# né la configurazione /usr/data/samba/smb.conf.
if command -v smbcontrol >/dev/null 2>&1; then
    smbcontrol all shutdown >/dev/null 2>&1 || true
fi

# Fallback per build Entware senza smbcontrol nel PATH.
if pidof smbd >/dev/null 2>&1; then
    killall smbd >/dev/null 2>&1 || true
fi

echo "Samba arrestato. Pacchetto e configurazione conservati."
