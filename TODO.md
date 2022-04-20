- Update GNOME-related packages (gnome-shell v42) when functional (use debs if available, otherwise zips):
  - [ ] filemanager-actions (deb-only)
  - [x] dash-to-panel (2022-04-20: ZIP, ext. v48)
  - [ ] panel-osd
- Ensure that GDM gets properly reset if wasta-gnome is uninstalled.
  - [ ] reset login screen background color and image
- Set lightdm to "conflicts"?
  - [x] ensure that wasta-multidesktop depends on slick-greeter|gdm3
- Enable support for Wayland
  - [x] add proper .desktop file to /usr/share/wayland-sessions
  - [x] ensure that /etc/gdm3/custom.conf does not have WaylandEnable=false

### Add packaged extension schemas to gsettings?


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
