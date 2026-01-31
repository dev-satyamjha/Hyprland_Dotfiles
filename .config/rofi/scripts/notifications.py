#!/usr/bin/python3

import subprocess
import json

data = subprocess.getoutput('makoctl history')

notifications = []

# new output looks like this (post v1.10.0-1)

# Notification 200: Charger Connected
#   App name: Power
#   Urgency: normal
#
# Notification 167: Connection Established
#   App name: NetworkManager Applet
#   Desktop entry: org.freedesktop.network-manager-applet
#   Urgency: normal
#   Actions:
#     app.enable-pref::disable-connected-notifications: Don’t show this message again
#
# Notification 162: Dheeraj Koder
#   App name: Zen
#   Desktop entry: Zen
#   Actions:
#     default: Activate

appName = ""
body = ""
for line in data.split("\n"):
    if line.startswith("Notification "):
        if appName and body:
            notifications.append(appName.title() + '\n' + body + '\n')
        appName = ""
        body = line.split(": ")[-1].strip()
        continue

    if "App name: " in line:
        appName = line.split(": ")[-1].strip()
    
# for n in data['data'][0]:
#     st = ""
#     st += n['app-name']['data'].title() + '\n'
#     st += n['body']['data'] + '\n'
#     notifications.append(st)

for i in notifications:
    print(i)
