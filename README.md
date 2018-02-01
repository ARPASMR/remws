# eiffel
REMWS eiffel code

This repository contains remws public eiffel code. Enjoy!

# Service daemon
Il demone del servizio si chiama remwsgwyd. 
Per fermarlo
```
# service remwsgwyd stop
```
Per lanciarlo
```
# service remwsgwyd start
```
prima di lanciare il precedente comando eseguire l'applicativo che effettua il logout dell'utente meteo dal remws, tale comando è 
```
# /sbin/unlogremws
```
oppure è possibile utilizzare il seguente script che esegue le operazioni necessarie in sequenza
```
# /root/scripts/restart_remwsgwyd.sh
```
## Opzioni
-p port (default 9090)

-l log level

-syslog usa syslog per le notifiche (default: false)

-h help

Per una lista completa di tuttle le opzioni consultare la relativa pagina del man.
