#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

qBittorrentEXE := "C:\Program Files\qBittorrent\qbittorrent.exe"

; Check if the file exists at the default location
if (!FileExist(qBittorrentExe)) {
    ; Prompt user for qBittorrent executable location if not found at default
    FileSelectFile, qBittorrentExe, 1, , Please select the qBittorrent executable (qbittorrent.exe).
    if (qBittorrentExe = "") {
        MsgBox, 4, , Please select the qBittorrent executable.
        ExitApp ; Exit the script if user cancels selection
    }
}

; Function definition for Get_qBittorrent_Dir
Get_qBittorrent_Dir() {
    ; Check if the file exists at the default location
    if (FileExist(qBittorrentExe)) {
        MsgBox, 2, , qBittorrent found at default location: %qBittorrentExe%
        return
    }
}

MAIN:
portPIA := ComObjCreate("WScript.Shell").Exec("C:\Progra~1\PRIVAT~1\piactl get portforward").StdOut.ReadAll()
StringTrimRight, portPIA_CLEAN, portPIA, 2
IniRead, Qport, %AppData%\qBittorrent\qBittorrent.ini, BitTorrent, Session\Port
Menu, tray, Add, PIA: %portPIA_CLEAN%, RunCommand
Menu, tray, Add, qBIT: %Qport%, RunCommand
Menu, tray, Add, Check Ports Now, RunCommand
Menu, Tray, Tip , PIA: %portPIA_CLEAN%`nqBIT: %Qport%
sleep, 100
If Qport = %portPIA_CLEAN%
    gosub Sleep
else
    gosub Setport

RunCommand:
if (A_ThisMenuItem = "Check Ports Now")
    Get_qBittorrent_Dir() ; Call the function again to potentially update path
Return

Setport:
MsgBox, 1, PF_Watchdog, qBittorent Port: %Qport%`nPIA VPN Port: %portPIA_CLEAN%`nQuitting qBittorrent and changing port., 5
IfMsgBox OK
{
    gosub updatePORT
}
IfMsgBox Cancel
{
    ExitApp
}
gosub updatePORT

updatePORT:
Runwait, Taskkill /IM qBit* /F
Sleep, 300
IniWrite, %portPIA_CLEAN%, %AppData%\qBittorrent\qBittorrent.ini, BitTorrent, Session\Port
Sleep, 300
Run, %qBittorrentExe% ; Use the user-selected executable path
gosub Sleep

Sleep:
Sleep, 3600000 ; Sleep for 1 hour
gosub MAIN