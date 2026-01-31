#!/bin/python3

# SETTINGS
TIME = 300 # seconds
FANCY = True # causes applications to lag on my machine
WALLPAPER_DIRECTORY = "/home/satyam/Personaization/Wallpapers/"

# CODE
import os
import random
import subprocess
import threading

def command(cmd):
    return os.popen(cmd).read().strip()

# This is a workaround related to swww-daemon crashing randomly since 0.7.x
command("rm -rf  ~/.cache/swww/")

if command("pidof swww-daemon") == "":
    command("swww init")

command("killall swaybg")

wallpaperDir = os.path.expanduser(WALLPAPER_DIRECTORY)
wallpaperMemory = []

def set_interval(func, sec):
    def func_wrapper():
        set_interval(func, sec)
        func()
    t = threading.Timer(sec, func_wrapper)
    t.start()
    return t

def set_wallpaper():
    if os.path.exists(os.path.expanduser("~/.disable-random-wallpaper")):
        print("~/.disable-random-wallpaper found: script disabled!")
        return

    global wallpaperDir
    global wallpaperMemory
    global monitors
    global FANCY

    print("changing wallpaper...")
    print("memory size: " + str(len(wallpaperMemory)))
    print("memory content: ")
    for string in wallpaperMemory:
        print(" - " + string)

    wallpapers = os.listdir(wallpaperDir)
    wallpapers = [x for x in wallpapers if not os.path.isdir(x)]

    if len(wallpaperMemory) != 0:
        for entry in wallpaperMemory:
            try:
                wallpapers.remove(entry)
            except:
                # We need something here because python
                print("Could not find current wallpaper in wallpaper folder!")

    selectedWallpapers = []

    wp = wallpapers.pop(random.randint(0, len(wallpapers)-1))
    if FANCY:
        print(f"Changing to {wallpaperDir}/{wp}")
        command(f"swww img \"{wallpaperDir}/{wp}\" --transition-type random")
    else:
        command("swww img -t none -o " + output + " " + wallpaperDir + "/" + wp) # --transition-type simple --transition-step 30 
    selectedWallpapers.append(wp)

    wallpaperMemory = selectedWallpapers
    return

set_wallpaper()
set_interval(set_wallpaper,TIME)
