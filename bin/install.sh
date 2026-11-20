#!/bin/sh
set -eu

OPKG=/opt/bin/opkg
SMBD=/opt/sbin/smbd
CONF=/usr/data/samba/smb.conf

# Attendi Entware: massimo 120 secondi.
i=0
while [ ! -x "$OPKG" ] && [ "$i" -lt 40 ]; do
    i=$((i + 1))
    sleep 3
done

[ -x "$OPKG" ] || {
    echo "ERROR: Entware non disponibile (/opt/bin/opkg)."
    exit 1
}

# Installa Samba solo se il binario non è presente.
if [ ! -x "$SMBD" ]; then
    "$OPKG" update
    "$OPKG" install samba4-server
fi

[ -x "$SMBD" ] || {
    echo "ERROR: installazione samba4-server fallita."
    exit 1
}

# Crea la configurazione solo se non esiste: le modifiche dell'utente
# vengono preservate anche durante gli aggiornamenti.
if [ ! -f "$CONF" ]; then
    mkdir -p "$(dirname "$CONF")"
    cat > "$CONF" <<'EOF'
[global]
workgroup = WORKGROUP
server role = standalone server
map to guest = Bad User
min protocol = SMB2
log file = /opt/var/log/samba/log.%m
max log size = 500
lock directory = /opt/var/samba/lock
state directory = /opt/var/samba
cache directory = /opt/var/samba
pid directory = /opt/var/run
private dir = /opt/var/samba/private

[printer_data]
path = /usr/data
browseable = yes
read only = no
guest ok = yes
force user = root

#[printer_progr]
#path = /usr/prog
#browseable = yes
#read only = no
#guest ok = yes
#force user = root
EOF
    echo "Creata configurazione: $CONF"
else
    echo "Configurazione esistente preservata: $CONF"
fi

mkdir -p \
    /opt/var/log/samba \
    /opt/var/samba/lock \
    /opt/var/samba/private \
    /opt/var/run/samba

echo "Samba Share installato."
