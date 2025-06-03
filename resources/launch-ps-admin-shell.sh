#!/bin/bash

# Description:
# Lauches a Powershell Admin window on the desktop at the current WSL directory. Useful for popping into powershell for a quick admin task from WSL. For example, running 'vagrant up'
#
# Recomended: 
# /opt/utiles-and-scripts/wsl/launch-ps-admin-shell.sh
# alias psadmin=/opt/utils-and-scripts/wsl/launch-ps-admin-shell.sh


WINUSER=$(powershell.exe '[System.Environment]::UserName' | tr -d '\r')
WINPATH=$(wslpath -w "$PWD")

powershell.exe -Command "Start-Process 'C:\\Users\\$WINUSER\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Windows PowerShell\\Windows PowerShell.lnk' -ArgumentList '-NoExit', '-Command', 'cd \"$WINPATH\"' -Verb RunAs"