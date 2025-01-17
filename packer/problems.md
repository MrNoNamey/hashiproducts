# Packer x Vagrant

## Software
- Packer
- Vagrant
- VirtualBox

## Probleme und Umgang damit

### Rekursive VMs
Zu Beginn wurde versucht, den gesamten Prozess in einer vm zu realisieren. Dies ist gescheitert, als mit Vagrant eine weitere VM erstellt werden sollte, das das Erstellen einer VM innerhalb einer weiteren VM nicht ohne weiteres möglich ist

_Versuchte Problembehandlung_

- Aktivieren von Nested AMD-V in der VM über VirtualBox Manager
- Aktivieren von CPU-Virtualisierung im BIOS der VM

### Waiting for SSH to become available
Nach dem Hochfahren der VM wird darauf gewartet, dass eine SSH Verbindung zu dieser hergestellt werden kann.

_Versuchte Problembehandlung_
- SSH manuell aufbauen
- SSH nach Provisionierung der VM entfernen
- Aktivieren von NAT (Networj Address Translation) & Porteweiterleitung auf der VM
- geänderte Konfiguration des Vagrantfiles um openssh-server auf VM zu installieren
- Erhöhen des Timeouts für den Aufbau der SSH Verbindung

## Für vagrant benötigtes .box-File nicht vorhanden
Vagrant benötigt .box-Files, die das Image für die VM enthalten. Dieses sollte auf dem Hostrechner beim Ausführen von packer build verfügbar sein.

_Verschte Problembehandlung_
- Anpassung und Kontroller des Outpt Wertes im Post-processor der Packer HCL-Datei
- Build mit -force erzwingen
- Build mit -debug für weitere Ausgaben, um Debugging zu verbessern
