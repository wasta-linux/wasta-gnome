- Set lightdm to "conflicts"
  - [ ] ensure that wasta-multidesktop depends on slick-greeter|gdm3
- Enable support for Wayland
  - [ ] add proper .desktop file to /usr/share/wayland-sessions
  - [ ] ensure that /etc/gdm3/custom.conf does not have WaylandEnable=false
  - [ ] ...

### Tests
1. Verify that gnome screensaver is enabled on login and disabled on logout
```bash
# After login:
$ ls /usr/share/dbus-1/services/org.gnome.ScreenSaver.service*
ls /usr/share/dbus-1/services/org.gnome.ScreenSaver.service
# After logout:
$ ls /usr/share/dbus-1/services/org.gnome.ScreenSaver.service*
/usr/share/dbus-1/services/org.gnome.ScreenSaver.service.disabled
```
1. Verify that app-folders get reset if arbitrarily set to "['Utilities', 'YaST']".
```bash
# After login:
$ gsettings set org.gnome.desktop.app-folders folder-children "['Utilities', 'YaST']"
$ gnome-session-quit --logout
# After re-login:
$ gesttings get org.gnome.desktop.app-folders folder-children
['Graphics', 'AudioVideo', 'Network', 'Office', 'Development', 'System', 'Settings', 'Utility', 'Game', 'Education', 'Wasta']
```
1. Verify that gsettings changes get propagated.
