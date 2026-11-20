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
5. Sprachsteuerung: Unter **Profil → Sicherheit** einen Langzeit-Zugriffstoken für
   Speech-to-Phrase erstellen und vor dem Deploy in sops secrets eintragen. Danach die
   Wyoming-Integration je Dienst hinzufügen (Host `127.0.0.1`, Port `10300` für
   Speech-to-Phrase, `10200` für Piper) und unter **Einstellungen → Sprachassistenten**
   Speech-to-Phrase als Spracherkennung und Piper als Sprachausgabe wählen.
   Erkannt werden nur Befehle für Entitäten, die für Assist freigegeben sind.
6. Matter over Thread: Den Thread-Stick vorher mit OpenThread-RCP-Firmware flashen
   (https://dongle.sonoff.tech). Danach die Integration **OpenThread Border Router** mit
   `http://127.0.0.1:8081` und die Integration **Matter** mit `ws://127.0.0.1:5580/ws`
   hinzufügen. Unter **Einstellungen → Geräte & Dienste → Thread → Konfigurieren** prüfen,
   dass das eigene Netz bevorzugt ist (setzt HA beim Einrichten automatisch), und über das
   ⋮-Menü des Border Routers „Kanal ändern“ auf **15** setzen (FRITZ!Box fest auf
   WLAN-Kanal 11, Zigbee auf 25). Geräte werden über die Companion App angelernt; dort
   zuerst unter **Einstellungen → Companion App → Problemlösungen** die
   Thread-Zugangsdaten synchronisieren.

   Ohne Handy über Bluetooth am Server: Bluetooth-Integration in HA hinzufügen, dann im
   Matter-Dashboard unter **Settings → Thread** den Datensatz aus
   `sudo ot-ctl dataset active -x` eintragen und unter **Nodes → Commission node** mit dem
   Kopplungscode anlernen. Das Gerät dabei in die Nähe des Servers halten.

Globale Z2M-Einstellungen in Nix ändern; UI-Änderungen daran werden beim Neustart
überschrieben. Geräte und Gruppen bleiben erhalten. PAN-IDs und Netzwerkschlüssel
nach dem Anlernen beibehalten.
