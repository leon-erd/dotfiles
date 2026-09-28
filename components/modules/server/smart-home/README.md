## Einmalige Einrichtung

Home Assistant verwaltet seine Konfiguration selbst. `haPort` setzt den initialen
Port; spätere Änderungen auch in der HA-Weboberfläche eintragen. Die HTTP-/Proxy-Einstellungen
müssen vor dem ersten Zugriff über Nginx in der Weboberfläche gesetzt werden
(https://www.home-assistant.io/integrations/http/#reverse-proxies):

1. SSH-Tunnel öffnen und `http://127.0.0.1:8123` im Browser aufrufen:
   ```sh
   ssh -N -L 127.0.0.1:8123:127.0.0.1:8123 <user>@<host>
   ```
2. HA-Benutzer anlegen. Unter **Einstellungen → System → Netzwerk → HTTP**:
   Listen-Adresse `127.0.0.1`, Port `8123`, **Trust X-Forwarded-For** aktivieren
   und `127.0.0.1/32` als **Trusted proxy** eintragen. Nach dem Neustart bestätigen;
   anschließend die HTTPS-Adresse verwenden.
3. MQTT-Integration hinzufügen: Broker `127.0.0.1`, Port `1883`, kein TLS,
   Benutzer `homeassistant`. Passwort in sops secrets.
4. Z2M-Login-Token in sops secrets.

Globale Z2M-Einstellungen in Nix ändern; UI-Änderungen daran werden beim Neustart
überschrieben. Geräte und Gruppen bleiben erhalten. PAN-IDs und Netzwerkschlüssel
nach dem Anlernen beibehalten.
