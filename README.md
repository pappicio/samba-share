# Samba Share — OpenCreator plugin

Plugin autonomo per Creator 5 / Creator 5 Pro in modalità SoC.
Non richiede Script Runner.

## Funzioni

- Installa `samba4-server` tramite Entware solo se `smbd` non è presente.
- Attende Entware per un massimo di 120 secondi.
- Crea `/usr/data/samba/smb.conf` solo se non esiste.
- Condivide `/usr/data` come `printer_data`, accessibile come guest in lettura/scrittura.
- Avvia `smbd` come servizio foreground supervisionato da OpenCreator.
- Non sovrascrive la configurazione durante gli aggiornamenti.

## Installazione

```sh
oc-plugin install https://github.com/pappicio/samba-share.git
```

## Gestione

```sh
oc-plugin status samba-share
oc-plugin logs samba-share smbd
oc-plugin restart samba-share smbd
```

## Configurazione

File: `/usr/data/samba/smb.conf`

La condivisione predefinita è:

- Nome: `printer_data`
- Percorso: `/usr/data`
- Guest: abilitato
- Scrittura: abilitata
- Utente forzato: `root`

Per modificare la condivisione, intervenire direttamente su `smb.conf`.
Gli aggiornamenti del plugin non modificano un file già esistente.

## Rimozione

```sh
oc-plugin remove samba-share
```

La rimozione arresta Samba, ma lascia installato `samba4-server` e conserva
`/usr/data/samba/smb.conf`.

## Compatibilità

Creator 5 e Creator 5 Pro. Il servizio viene eseguito sul sistema della
stampante; non richiede Script Runner.
