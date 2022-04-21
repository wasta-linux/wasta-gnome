- Split out packages for each gnome-shell-extension.
  - [x] applications-overview-tooltip
  - [x] dash-to-panel
  - [x] drive-menu (needs testing)
  - [ ] panel-osd
  - [x] windowIsReady_Remover
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
1. Verify that extensions work.
  - applications-overview-tooltip
    - hover mouse over app icons in the apps overlay to see tooltip
  - dash-to-panel
    - verify that dash+panel appears on bottom
    - verify that Wasta logo and default favorites appear in panel
  - desktop-icons-ng
    - copy a file to the desktop to see if the icon appears
  - drive-menu
    - insert USB device and verify that the icon appears in the panel
  - ubuntu-appindicators
    - launch zim [?] to see if indicator appears
  - window-is-ready-remover
    - open an app window and verify that no "_ is ready" popup appears
1. Verify that Wasta GNOME dconf customizations are applied.
  - verify blue underline for app icons, e.g.
