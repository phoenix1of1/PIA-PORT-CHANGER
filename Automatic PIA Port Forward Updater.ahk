#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

; Registry path to store qBittorrent path (escaped backslashes)
regPath := "HKEY_CURRENT_USER\Software\Automatic PIA Port Forward Updater"
RegRead, qBittorrentEXE, % regPath, qBittorrentPath

; Check if the registry key doesn't exist or path is empty
if (!qBittorrentEXE || qBittorrentEXE = "") {
    ; Prompt user for qBittorrent executable location if not found
    FileSelectFile, qBittorrentEXE, 1, , Please select the qBittorrent executable (qbittorrent.exe).
    if (qBittorrentEXE = "") {
        MsgBox, 4, , Please select the qBittorrent executable.
        ExitApp ; Exit the script if the user cancels the selection
    }
    ; Write the selected path to the registry for future use
    RegWrite, REG_SZ, %regPath%, qBittorrentPath, %qBittorrentEXE%
}

; Function definition for Get_qBittorrent_Dir
Get_qBittorrent_Dir() {
    ; Check if the file exists at the default location
    if (FileExist(qBittorrentEXE)) {
        MsgBox, 2, , qBittorrent found at the default location: %qBittorrentEXE%
        return
    }
}

; Expand the %AppData% variable to the actual directory path
EnvGet, expandedAppData, AppData
IniRead, Qport, %expandedAppData%\qBittorrent\qBittorrent.ini, BitTorrent, Session\Port

MAIN:
    portPIA := ComObjCreate("WScript.Shell").Exec("C:\Progra~1\PRIVAT~1\piactl get portforward").StdOut.ReadAll()
    StringTrimRight, portPIA_CLEAN, portPIA, 2
    Menu, tray, Add, PIA: %portPIA_CLEAN%, RunCommand
    Menu, tray, Add, qBIT: %Qport%, RunCommand
    Menu, tray, Add, Check Ports Now, RunCommand
    Menu, Tray, Tip , PIA: %portPIA_CLEAN%`nqBIT: %Qport%
    sleep, 100
    If Qport = %portPIA_CLEAN%
        gosub Sleep
    else
        gosub Setport
Return

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
Return

updatePORT:
    Runwait, Taskkill /IM qBit* /F
    Sleep, 300
    IniWrite, %portPIA_CLEAN%, %expandedAppData%\qBittorrent\qBittorrent.ini, BitTorrent, Session\Port
    Sleep, 300
    Run, %qBittorrentEXE% ; Use the user-selected executable path
    gosub Sleep

    Sleep:
    Sleep, 3600000 ; Sleep for 1 hour
    gosub MAIN