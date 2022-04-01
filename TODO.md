- Ensure that GDM gets properly reset if wasta-gnome is uninstalled.
  - [ ] reset login screen background color and image
- Set lightdm to "conflicts"
  - [ ] ensure that wasta-multidesktop depends on slick-greeter|gdm3
- Enable support for Wayland
  - [ ] add proper .desktop file to /usr/share/wayland-sessions
  - [ ] ensure that /etc/gdm3/custom.conf does not have WaylandEnable=false
  - [ ] ...

### Add packaged extension schemas to gsettings?

### Panels not getting moved to bottom

### Missing gsettings keys
- /usr/share/glib-2.0/schemas/z_12_wasta-gnome.gschema.override


### Tests
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
