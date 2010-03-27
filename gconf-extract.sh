#!/bin/bash 
MODULES=" \
Gnome_Firefox_default_browser|/desktop/gnome/applications/browser \
Gnome_window_manager|/desktop/gnome/applications/window_manager \
Gnome_metacity|/apps/metacity/global_keybindings \
Gnome_keybindings|/apps/metacity/keybinding_commands \
Gnome_workspace|/apps/metacity/workspace_names \
Gnome_terminal|/apps/gnome-terminal \
Rhytmbox|/apps/rhythmbox"


function dump_gconf {
    mkdir -p gconf
    for i in $MODULES; do
        module_name=$(echo $i | awk -F\| '{print $1}')
        module_path=$(echo $i | awk -F\| '{print $2}')
        echo -n "Dumping $module_name..."
        gconftool --dump $module_path > gconf/$module_name.xml
        echo "Ok"
    done
}

function load_gconf {
    for i in $MODULES; do
        module_name=$(echo $i | awk -F\| '{print $1}')
        module_path=$(echo $i | awk -F\| '{print $2}')
        gconftool --load gconf/$module_name.xml
    done
}

if [ $# -ge 1 ]; then 

    if [ $1 == "dump" ]; then
        dump_gconf
        exit 0
    else
        module_file=$1
    fi
fi

#load_gconf $module_file


