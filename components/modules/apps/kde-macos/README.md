# KDE-Apps auf macOS (Dolphin, Okular)

nixpkgs hat die `kdePackages` nur für Linux, Homebrew hat keine Casks dafür (`dolphin` ist
der GameCube-Emulator). Installiert wird deshalb von Hand; `kdeAppsMacos` verwaltet nur die
Konfiguration (rc-Dateien, Layan, Tela, ZIP-Kontextmenü).

## Okular

Nightly-DMG aus der KDE-CI (`cdn.kde.org/ci-builds/graphics/okular/release-*/macos-arm64/`),
`okular.app` nach `/Applications`.

## Dolphin

Kein fertiges macOS-Paket; mit [KDE Craft](https://community.kde.org/Get_Involved/development/Mac)
in einem Wegwerf-Ordner bauen (`CraftBootstrap.py --prefix <ordner> --use-defaults`,
`craft dolphin`, `craft --package dolphin`) und die App aus dem DMG nach `/Applications`
kopieren. Die App ist danach eigenständig, der Build-Ordner (ca. 5,5 GB) kann weg.

Stolperstellen:

- **Python:** Craft braucht ≥ 3.11, macOS hat 3.9 → z. B. `nix build nixpkgs#python312 -o <ordner>/python`.
- **Außerhalb des Ordners:** Craft loggt nach `~/.craft` (`[CraftDebug] LogDir` in
  `etc/CraftSettings.ini` umstellen).
- **kioworker:** Das Paket legt ihn unter `Contents/MacOS/kf6/` ab, KIO sucht ihn in
  `Contents/MacOS/` → kopieren. Ohne ihn keine Dateiliste.
- **Info.plist:** `CFBundleIdentifier`/`CFBundleName` sind leer → `org.kde.dolphin`/`Dolphin`
  setzen, sonst findet LaunchServices/Spotlight die App schlecht.
- **Signatur:** Nach Änderungen am Bundle `codesign --force --deep -s - dolphin.app`.
- **Absturz beim Fokussieren** (Accessibility, sobald z. B. AeroSpace/AutoRaise laufen): Qts
  Cocoa-Plugin löscht während `QAccessible::updateAccessibility()` Dolphins
  `KItemListViewAccessible`. Fix: `setAccessibleFocusAndAnnounceAll()` und
  `slotAnnounceCurrentItemTimerTimeout()` unter `Q_OS_MACOS` sofort verlassen.
- **Zeilenstreifen trotz Farbschema:** `KItemListView::itemChange()` kopiert die Palette der
  `QGraphicsView` nur einmal, bevor das Farbschema gesetzt ist. Fix: in
  `KItemListContainer` bei `QEvent::PaletteChange` des Viewports die Palette per
  `setStyleOption()` an die View weiterreichen.