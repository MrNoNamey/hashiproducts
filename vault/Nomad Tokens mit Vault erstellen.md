# Anleitung: Vault Tokens für die Authentifizierung in Nomad erstellen

## Schritt 1 - Konfigurationsdateien erstellen
1. Erstelle zwei Dateien mit den Namen `nomad.hcl` und `vault.hcl`.
2. Öffne die Dateien und füge Folgendes ein:

   ```
   acl {
     enabled = true
   }
3. Alternativ können die Dateien auch aus dem Repository heruntergeladen werden.
## Schritt 2 - Vault aufsetzen
1. Starte den Vault Server mit dem folgenden Befehl
`vault server -config="pfad/zur/config/datei" -dev`
## Schritt 3 - Nomad aufsetzen
1. Starte den Nomad Server mit dem folgenden Befehl
`nomad agent -dev -config=”pfad/zur/config/datei”`
## Schritt 4 - Nomad Token erstellen
1. Nutze den folgenden Befehl um einen access Token für Nomad zu erstellen
`nomad acl bootstrap`
## Schritt 5 - Nomad Secrets Engine in Vault aktivieren
1. Aktiviere die Nomad Secrets Engine in Vault:
`vault secrets enable nomad`
2. Konfiguriere den Zugriff:
`vault write nomad/config/access \
address=http://127.0.0.1:4646 \
token=<Access-Token aus Schritt 4>`
3. Erstelle eine Rolle für die Nomad Engine:
`vault write nomad/role/<rollen-name> \
policies=policyone,policytwo`
## Schritt 6: ACL Policy in Vault einrichten
1. Erstelle in der Vault-Web-UI eine neue ACL Policy mit dem Namen `nomad-policy`.
2. Füge diesen Inhalt ein:
`path "nomad/creds/<rollen-name>" {
  capabilities = ["read"]
}`
## Schritt 7: Tokens erstellen
1. Erstelle einen temporären Token mit diesem Befehl:
`vault token create -policy=nomad-user-policy`
2. Lies den erstellten Token aus und nutze ihn in Nomad:
`vault read nomad/creds/<rollen-name>`

