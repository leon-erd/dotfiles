import dbus
from dbus.bus import BusConnection
import time
import subprocess
from datetime import datetime
from tzlocal import get_localzone_name
from zoneinfo import ZoneInfo
from astral import Observer
from astral.sun import elevation as sun_elevation


class GeoClueClient:
    def __init__(self, desktop_id="my_hyprsunset.py", accuracy=4):
        self.bus = BusConnection("unix:path=/run/dbus/system_bus_socket")
        manager = dbus.Interface(
            self.bus.get_object(
                "org.freedesktop.GeoClue2", "/org/freedesktop/GeoClue2/Manager"
            ),
            "org.freedesktop.GeoClue2.Manager",
        )
        self.client_path = manager.CreateClient()
        proxy = self.bus.get_object("org.freedesktop.GeoClue2", self.client_path)
        self.client = dbus.Interface(proxy, "org.freedesktop.GeoClue2.Client")
        self.props = dbus.Interface(proxy, "org.freedesktop.DBus.Properties")

        self.props.Set(
            "org.freedesktop.GeoClue2.Client", "DesktopId", dbus.String(desktop_id)
        )
        self.props.Set(
            "org.freedesktop.GeoClue2.Client",
            "RequestedAccuracyLevel",
            dbus.UInt32(accuracy),
        )

    def get_location(self):
        # Start → wait for Location property → read coords → Stop
        self.client.Start()
        loc_path = self.props.Get("org.freedesktop.GeoClue2.Client", "Location")
        while not loc_path or loc_path == "/":
            time.sleep(0.5)
            loc_path = self.props.Get("org.freedesktop.GeoClue2.Client", "Location")

        # Fetch the latitude & longitude
        loc = self.bus.get_object("org.freedesktop.GeoClue2", loc_path)
        loc_props = dbus.Interface(loc, "org.freedesktop.DBus.Properties")
        lat = float(loc_props.Get("org.freedesktop.GeoClue2.Location", "Latitude"))
        lon = float(loc_props.Get("org.freedesktop.GeoClue2.Location", "Longitude"))

        self.client.Stop()
        return lat, lon


def calculate_temp_from_elevation(elev, day_temp=6000, night_temp=3000):
    # Between 0° and –18° sun elevation the brightness falls off roughly exponentially
    # A rule-of-thumb is “one 10th of illuminance per 6°”
    s = min(0.0, elev)
    r = 10 ** (s / 6.0)
    return int(night_temp + r * (day_temp - night_temp))


def set_temp(temp):
    command = ["hyprctl", "hyprsunset", "temperature", f"{temp}"]
    print(f"Executing command: {' '.join(command)}")
    subprocess.run(command, check=False)


def main():
    time_zone = ZoneInfo(get_localzone_name())
    geoclue_client = GeoClueClient()
    lat, lon = geoclue_client.get_location()
    observer = Observer(latitude=lat, longitude=lon)
    print(f"Your location:  lat={lat:.6f}, lon={lon:.6f}")

    last_temp = None
    while True:
        now = datetime.now(tz=time_zone)
        elev = sun_elevation(observer, now)
        temp = calculate_temp_from_elevation(elev)
        if temp != last_temp:
            print(
                f"Time: {now.time()}, Sun elevation: {elev:.2f}° → Temperature: {temp}"
            )
            set_temp(temp)
            last_temp = temp
        time.sleep(300)


if __name__ == "__main__":
    main()
