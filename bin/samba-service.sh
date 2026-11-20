#!/bin/sh
set -eu

SMBD=/opt/sbin/smbd
CONF=/usr/data/samba/smb.conf

[ -x "$SMBD" ] || {
    echo "ERROR: smbd non installato."
    exit 1
}

[ -f "$CONF" ] || {
    echo "ERROR: configurazione Samba assente: $CONF"
    exit 1
}

mkdir -p \
    /opt/var/log/samba \
    /opt/var/samba/lock \
    /opt/var/samba/private \
    /opt/var/run/samba

# Se esiste già un'istanza avviata manualmente, la arresta
# per trasferire la gestione al servizio OpenCreator.
if pidof smbd >/dev/null 2>&1; then
    if command -v smbcontrol >/dev/null 2>&1; then
        smbcontrol all shutdown >/dev/null 2>&1 || true
    else
        killall smbd >/dev/null 2>&1 || true
    fi

    i=0
    while pidof smbd >/dev/null 2>&1 && [ "$i" -lt 10 ]; do
        i=$((i + 1))
        sleep 1
    done

    if pidof smbd >/dev/null 2>&1; then
        killall smbd >/dev/null 2>&1 || true
        sleep 1
    fi
fi

# Foreground: OpenCreator supervisiona il processo e lo riavvia
# automaticamente se termina inaspettatamente.
exec "$SMBD" -F -s "$CONF"
