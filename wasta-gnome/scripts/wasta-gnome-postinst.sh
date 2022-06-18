#!/bin/bash

# ==============================================================================
# wasta-gnome-postinst.sh
#
#   This script is automatically run by the postinst configure step on
#       installation of wasta-gnome. It can be manually re-run, but
#       is only intended to be run at package installation.
#
#   2020-07-22 ndm: initial script
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
if [ $(id -u) -ne 0 ]
then
	echo
	echo "You must run this script with sudo." >&2
	echo "Exiting...."
	sleep 5s
	exit 1
fi

# ------------------------------------------------------------------------------
# Initial setup
# ------------------------------------------------------------------------------
echo
echo "*** Script Entry: wasta-gnome-postinst.sh"
echo

# Setup Directory for later reference
DIR=/usr/share/wasta-gnome

# ------------------------------------------------------------------------------
# General initial config
# ------------------------------------------------------------------------------

# Set GDM3 default config.
if [[ -e /etc/gdm3 ]]; then
	# Enable GDM3 debug logs (to capture session names).
	gdm_custom_conf=/etc/gdm3/custom.conf
	if [[ ! -e ${gdm_custom_conf}.orig ]]; then
		mv $gdm_custom_conf{,.orig}
	fi
	cat > $gdm_custom_conf << EOF
[debug]
Enable=true
EOF

	# Add Wasta logo to GDM3 greeter.
	gdm_greeter_conf=/etc/gdm3/greeter.dconf-defaults
	if [[ ! -e ${gdm_greeter_conf}.orig ]]; then
		mv $gdm_greeter_conf{,.orig}
	fi
	#	Ref: https://wiki.debian.org/GDM
	cat > $gdm_greeter_conf << EOF
[org/gnome/login-screen]
logo='/usr/share/plymouth/themes/wasta-logo/wasta-linux.png'
EOF

	# Change GDM3 greeter background color.
	#	Ref: https://github.com/thiggy01/change-gdm-background/blob/master/change-gdm-background
	/usr/share/wasta-gnome/scripts/change-gdm3-background.sh '#3C3C3C'
fi

# Add Wasta icon to slick-greeter desktop entry if slick-greeter is installed.
badges_dir=/usr/share/slick-greeter/badges
wasta_gnome_badge=${badges_dir}/wasta-gnome.svg
if [[ -d $badges_dir ]] && [[ ! -e $wasta_gnome_badge ]]; then
	cp -l /usr/share/wasta-multidesktop/resources/wl-round-22.svg "$wasta_gnome_badge"
fi

# Disable gnome-screensaver by default (re-enabled at wasta-gnome session login).
#if [[ -e /usr/share/dbus-1/services/org.gnome.ScreenSaver.service ]]; then
#    mv /usr/share/dbus-1/services/org.gnome.ScreenSaver.service{,.disabled}
#fi

# ------------------------------------------------------------------------------
# Dconf / Gsettings Default Value adjustments
# ------------------------------------------------------------------------------
echo "*** Updating dconf / gsettings default values"

# MAIN System schemas: we have placed our override file in this directory
# Sending any "error" to null (if key not found don't want to worry user)
glib-compile-schemas /usr/share/glib-2.0/schemas/ > /dev/null 2>&1 || true;

# ------------------------------------------------------------------------------
# Setting initial Nautilus config
# ------------------------------------------------------------------------------
echo "*** Setting initial Nautilus config"

# Update config for existing users.
#	 Future user config copied to /etc/skel by debian/install.
users=$(find /home/* -maxdepth 0 -type d | cut -d '/' -f3)
src_scripts_dir="${DIR}/nautilus-scripts"
src_templates_dir="${DIR}/templates"
while read -r user; do
    if [[ $(grep "$user:" /etc/passwd) ]]; then
        # Copy scripts.
		user_scripts_dir="/home/${user}/.local/share/nautilus/scripts"
		sudo --user="$user" mkdir --parents "$user_scripts_dir"
		# Don't copy any files that already exist; user may have updated them.
		cp --no-clobber --recursive "${src_scripts_dir}/"* "$user_scripts_dir"
		chown --recursive $user:$user "$user_scripts_dir"

		# Copy templates.
		user_templates_dir="$(sudo --user="$user" xdg-user-dir TEMPLATES)"
		sudo --user="$user" mkdir --parents "$user_templates_dir"
		# Don't copy any files that already exist; user may have updated them.
		cp --no-clobber --recursive "${src_templates_dir}/"* "$user_templates_dir"
		chown --recursive $user:$user "$user_templates_dir"
    fi
done <<< "$users"

echo "*** Need to reboot for changes to take effect."
echo "*** \"Wasta GNOME\" will be available as an alternative session at the login screen."
echo

# Require reboot to ensure gdm3 is eventually restarted.
echo "*** System restart required ***" > /var/run/reboot-required

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
echo
echo "*** Script Exit: wasta-gnome-postinst.sh"
echo

exit 0