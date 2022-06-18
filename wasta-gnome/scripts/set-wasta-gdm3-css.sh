#!/usr/bin/env bash
# Autor: Thiago Silva
# Contact: thiagos.dasilva@gmail.com
# URL: https://github.com/thiggy01/ubuntu-20.04-change-gdm-background
# Updated by Nate Marti, 2022.
# =================================================================== #

# Check if script is run by root.
if [ "$(id -u)" -ne 0 ] ; then
    echo 'This script must be run as root or with the sudo command.'
    exit 1
fi

# Check what linux distro is being used.
distro="$(lsb_release -c | cut -f 2)"
if ! [[ "$distro" =~ (focal|groovy|jammy) ]]; then
    echo 'Sorry, this script only works with focal, groovy, or jammy distros.'
    exit 1
fi

# Assign the default gdm theme file path.
if [ "$(lsb_release -i | awk '{print $3}')" == 'Ubuntu' ]; then
    gdm3Resource=/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
elif [ "$(lsb_release -i | awk '{print $3}')" == 'Pop' ]; then
    gdm3Resource=/usr/share/gnome-shell/theme/Pop/gnome-shell-theme.gresource
fi

# Create a backup file of the original theme if there isn't one.
[ ! -f "$gdm3Resource"~ ] && cp "$gdm3Resource" "$gdm3Resource~"

# Restore backup function.
restore () {
    mv "$gdm3Resource~" "$gdm3Resource"
    if [ "$?" -eq 0 ]; then
        chmod 644 "$gdm3Resource"
        echo 'GDM background sucessfully restored.'
        read -p 'Do you want to restart gdm to apply change? (y/n):' -n 1
    	echo
    	if [[ "$REPLY" =~ ^[yY]$ ]]; then
    	    service gdm restart
    	else
    	    echo 'Restart GDM service to apply change.'
    	    exit 0
    	fi
    fi
}

# Restore the original gdm3 theme.
[ "$1" == "--restore" ] && restore

#Define main variables.
gdm3xml=$(basename "$gdm3Resource").xml
workDir="/tmp/gdm3-theme"

# Change background colors.
# Store selected background color.
BgColor="#3C3C3C"
LoginTextColor="#1D1D1D"
LoginBgColor="#F7F7F7"

# Create working dirs.
for resource in `gresource list "$gdm3Resource~"`; do
    resource="${resource#\/org\/gnome\/shell\/}"
    if [ ! -d "$workDir"/"${resource%/*}" ]; then
      mkdir -p "$workDir"/"${resource%/*}"
    fi
done

# Extract resources into working dirs.
for resource in `gresource list "$gdm3Resource~"`; do
    gresource extract "$gdm3Resource~" "$resource" > \
    "$workDir"/"${resource#\/org\/gnome\/shell\/}"
done

# Change gdm background to the color you submited.
oldBg="#lockDialogGroup \{.*?\}"
newBg="#lockDialogGroup {
  background-color: $BgColor; }"
perl -i -0777 -pe "s/$oldBg/$newBg/s" "$workDir"/theme/gdm.css

# Change gdm text entry background and text colors.
oldLoginEntry=".login-dialog StEntry \{.*?\}"
newLoginEntry=".login-dialog StEntry {
  color: $LoginTextColor;
  background-color: $LoginBgColor; }"
perl -i -0777 -pe "s/$oldLoginEntry/$newLoginEntry/s" "$workDir"/theme/gdm.css

# Generate the gresource xml file.
echo '<?xml version="1.0" encoding="UTF-8"?>
<gresources>
<gresource prefix="/org/gnome/shell/theme">' > "$workDir"/theme/"$gdm3xml"
for file in `gresource list "$gdm3Resource~"`; do
echo "        <file>${file#\/org\/gnome/shell\/theme\/}</file>" \
>> "$workDir"/theme/"$gdm3xml"
done
echo '    </gresource>
</gresources>' >> "$workDir"/theme/"$gdm3xml"

# Compile resources into a gresource binary file.
glib-compile-resources --sourcedir=$workDir/theme/ $workDir/theme/"$gdm3xml"
# Move the generated binary file to the gnome-shell folder.
mv $workDir/theme/gnome-shell-theme.gresource $gdm3Resource

# Check if gresource was sucessfuly moved to its default folder.
if [ "$?" -eq 0 ]; then
    # Solve a permission change issue (thanks to @huepf from github).
    chmod 644 "$gdm3Resource"
    echo '*** GDM background sucessfully changed.'
    # Require reboot to ensure gdm3 is eventually restarted.
    echo "*** System restart required ***" > /var/run/reboot-required
else
    # If something went wrong, restore backup file.
    echo 'Something went wrong.'
    restore
    echo 'No changes were applied.'
fi

# Remove temporary files and exit.
rm -rf "$workDir"
