#!/bin/bash

set -euo pipefail

DEST="$HOME/Documents/Hyprland/Hyprland_Dotfiles"
DEST_CONFIG="$DEST/.config"
DEST_HOME="$DEST/home"

DEST_ETC="$DEST/etc"

mkdir -p "$DEST" || { echo "Error: Failed to create $DEST"; exit 1; }
mkdir -p "$DEST_CONFIG" || { echo "Error: Failed to create $DEST_CONFIG"; exit 1; }
mkdir -p "$DEST_HOME" || { echo "Error: Failed to create $DEST_HOME"; exit 1; }
mkdir -p "$DEST_ETC" || { echo "Error: Failed to create $DEST_ETC"; exit 1; }

truncate -s 0 "$DEST/rsync.log" 2>/dev/null

# archive mode, recursive, human readable, quite, stats (doesn't work), delete
RSYNC_FLAGS="-arhq --stats --delete --log-file=$DEST/rsync.log"

backup_dir() {
	local source_dir="$1"
  	local dest_dir="$2"

  	if [ -d "$source_dir" ]; then
    	# echo "Backing up $source_dir to $dest_dir"
    	
    	rsync $RSYNC_FLAGS "$source_dir" "$dest_dir"
    	
    	if [ $? -ne 0 ]; then
      		echo "Error: Failed to rsync $RSYNC_FLAGS $source_dir to $dest_dir" >&2
      		return 1
    	fi
  	else
    	echo "Directory $source_dir does not exist."
    fi
}

backup_file() {
	local source_file="$1"
	local dest_dir="$2"

	if [ -f "$source_file" ]; then
		# echo "Backing up $source_file to $dest_dir"
		
		rsync $RSYNC_FLAGS "$source_file" "$dest_dir"
		
		if [ $? -ne 0 ]; then
			echo "Error: Failed to rsync $RSYNC_FLAGS $source_file to $dest_dir" >&2
			return 1
		fi
	else
		echo "File $source_file does not exist."
	fi
}

create_empty_file() {
	local source_file="$1"
	local dest_dir="$2"
	local content="$3"

	# Check if the destination directory exists
	if [ ! -d "$dest_dir" ]; then
	  	echo "Error: Destination directory $dest_dir does not exist." >&2
	  	return 1
	fi

	# Check if the file already exists
	if [ -f "$dest_dir/$source_file" ]; then
	  	echo "File $dest_dir/$source_file already exists."
	  	return 0
	fi

	# Create the empty file
	echo "Creating empty $source_file in $dest_dir"
	echo "$content" > "$dest_dir/$source_file"

	if [ $? -eq 0 ]; then
		echo "Successfully created $dest_dir/$source_file"
	else
		echo "Error creating $dest_dir/$source_file" >&2
	  	return 1
	fi
}


# Backup user-scripts
backup_dir "$HOME/user-scripts" "$DEST"


# Backup Hyprland configuration
backup_dir "$HOME/.config/hypr" "$DEST_CONFIG"
backup_dir "$HOME/.config/mako" "$DEST_CONFIG"
backup_dir "$HOME/.config/satty" "$DEST_CONFIG"
backup_dir "$HOME/.config/rofi" "$DEST_CONFIG"
backup_dir "$HOME/.config/swaync" "$DEST_CONFIG"
backup_dir "$HOME/.config/swayidle" "$DEST_CONFIG"
backup_dir "$HOME/.config/waybar" "$DEST_CONFIG"
backup_dir "$HOME/.config/waypaper" "$DEST_CONFIG"
backup_dir "$HOME/.config/wlogout" "$DEST_CONFIG"
backup_dir "$HOME/.config/nwg-look" "$DEST_CONFIG"
backup_dir "$HOME/.config/nwg-launchers" "$DEST_CONFIG"
backup_dir "$HOME/.config/powernotd" "$DEST_CONFIG"

# Backup Zed configuration
backup_dir "$HOME/.config/zed" "$DEST_CONFIG"

# albert
backup_dir "$HOME/.config/albert" "$DEST_CONFIG"

# fusuma
backup_dir "$HOME/.config/fusuma" "$DEST_CONFIG"

# lazygit
backup_dir "$HOME/.config/lazygit" "$DEST_CONFIG"

# starship
backup_file "$HOME/.config/starship.garuda.toml" "$DEST_CONFIG"
backup_file "$HOME/.config/starship.new.toml" "$DEST_CONFIG"
backup_file "$HOME/.config/starship.toml" "$DEST_CONFIG"

# tlp
backup_file "/etc/tlp.conf" "$DEST_ETC"