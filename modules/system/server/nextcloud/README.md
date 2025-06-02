Some things cannot be configured declaratively and therefore have to be set manually. The following things have to be set after the first installation and are then stored in the database. Thus, when restoring a backup of a previously configured nextcloud instance (including data, config, and database) it should already be set.
- disable annoying apps: dashboard, first run wizard, recommendations, weather status
- update/insert customcss
- add logo/background
- setup users, groups, update notifications, email server
- setup previewgenerator:
    - do not use setup from previewgenerator github but instead setup as defined in the following (otherwise some previews needed for android app are missing):
    - https://web.archive.org/web/20220531105303/https://ownyourbits.com/2019/06/29/understanding-and-improving-nextcloud-previews/
 ```sh
# have to be set manually
occ config:app:set previewgenerator squareSizes --value="32 256"
occ config:app:set previewgenerator widthSizes  --value="256 384"
occ config:app:set previewgenerator heightSizes --value="256"
occ config:app:set preview jpeg_quality --value="60"
# the following are already set in nextcloud.nix
occ config:system:set preview_max_x --value 2048
occ config:system:set preview_max_y --value 2048
occ config:system:set jpeg_quality --value 60
```