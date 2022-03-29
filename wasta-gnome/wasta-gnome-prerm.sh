#!/bin/bash

# ==============================================================================
# wasta-gnome-postinst.sh
#
#   This script is automatically run by the prerm remove/purge step on
#       installation of wasta-gnome. It can be manually re-run, but
#       is only intended to be run at package installation.
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
echo "*** Script Entry: wasta-gnome-postrm.sh"
echo

# ------------------------------------------------------------------------------
# General initial config
# ------------------------------------------------------------------------------

# Assign the default gdm theme file path.
if [ "$(lsb_release -i | awk '{print $3}')" == 'Ubuntu' ]; then
    gdm3Resource=/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
elif [ "$(lsb_release -i | awk '{print $3}')" == 'Pop' ]; then
    gdm3Resource=/usr/share/gnome-shell/theme/Pop/gnome-shell-theme.gresource
fi

# Reset GDM3 login screen color.
if [[ -f "$gdm3Resource~" ]]; then
	mv "$gdm3Resource~" "$gdm3Resource"
fi

# Reset GDM3 login screen image.
gdm_greeter_conf=/etc/gdm3/greeter.dconf-defaults
if [[ -f "${gdm_greeter_conf}.orig" ]]; then
	mv $gdm_greeter_conf{.orig,}
fi

# Reset GDM3 default config.
gdm_custom_conf=/etc/gdm3/custom.conf
if [[ -f "${gdm_custom_conf}.orig" ]]; then
	mv $gdm_custom_conf{.orig,}
fi

# Remove PostLogin script.
gdm_default=/etc/gdm3/PostLogin/Default
rm -f $gdm_default

echo
echo "*** Restarting GNOME Shell"
echo
killall -SIGQUIT gnome-shell

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
echo
echo "*** Script Exit: wasta-gnome-postinst.sh"
echo

exit 0
