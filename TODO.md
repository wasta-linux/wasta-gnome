- [ ] Consider splitting out packages for each gnome-shell-extension.
  - [ ] applications-overview-tooltip
  - [x] dash-to-panel (needs testing)
  - [ ] drive-menu
  - [ ] panel-osd
  - [ ] windowIsReady_Remover
  - See http://fr.archive.ubuntu.com/ubuntu/pool/main/g/gnome-shell-extension-appindicator/gnome-shell-extension-appindicator_42-2~fakesync1_all.deb
  - Figure out how to create XML file for glib-2.0/schemas/org.gnome.shell.extensions.EXTENSION-NAME.gschema.xml
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
