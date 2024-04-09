# PIA-PORT-CHANGER

Enuring you never have to manually set the PIA Forwarded Port in qBittorrent ever again!

## Updates

Amended the .ahk to prompt users to identify where the qBittorrent.exe is stored because no one would store it on their OS drive right? Hehe!

Repackaged the .ahk in to a .exe with the amended user interaction.

Updated instructions for use.

### Instructions

Download the Automatic PIA Port Forward Updater.exe and store in any desired location.

Run Private Internet Access.
Connect to your server of choice.

If you can't see a port being forwarded on the PIA client, enter the client settings and opt to have a port forwarded upon connecting to a server.

Reconnect to the PIA server.
A port forwarded number should now show on the PIA Client.

Run the Automatic PIA Port Forward Updater.exe

The program will kill any running instances of qBittorrent, note the port being forwarded by PIA and then restart qBittorrent with the correct forwarded port number in the qBittorrent client settings.

### What's the advantage of using this script?

It not only removes the need for you to copy and paste the port number being forwarded from the PIA client to the qBittorrent client but it also automatically launches qBittorrent so all you have to do is ensure you are connected to a PIA server and run the script which saves you many precious mouse clicks!
