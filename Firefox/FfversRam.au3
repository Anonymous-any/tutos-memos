#NoTrayIcon

; ================================
; CONFIGURATION
; ================================
Global $RAMDISK = "Y:\profileFf"
Global $PROFILE_DISK = @AppDataDir & "\Mozilla\Firefox\Profiles\xxxxxxx.default"
Global $FIREFOX_EXE = "C:\Program Files\Mozilla Firefox\firefox.exe"

Global $WAIT_MS   = 300000 ; 5 minutes en millisecondes
Global $SLEEP_MS  = 3000   ; pause entre chaque vérification (3 s)

; ================================
; CREATION RAMDISK SI BESOIN
; ================================
If Not FileExists($RAMDISK) Then DirCreate($RAMDISK)

; ================================
; COPIE INITIALE (DISQUE -> RAM)
; ================================
RunWait('robocopy "' & $PROFILE_DISK & '" "' & $RAMDISK & '" /MIR /R:0 /W:0 /XD "safebrowsing" "startupCache" /XF *.sqlite-wal *.sqlite-shm', "", @SW_HIDE)

; ================================
; LANCEMENT FIREFOX
; ================================
Run('"' & $FIREFOX_EXE & '" -profile "' & $RAMDISK & '"')

; ================================
; BOUCLE DE SAUVEGARDE
; ================================
While ProcessExists("firefox.exe")

    ; ================================
    ; Sauvegarde périodique
    ; ================================
    RunWait('robocopy "' & $RAMDISK & '" "' & $PROFILE_DISK & '" /MIR /R:0 /W:0 /XD "safebrowsing" "startupCache" /XF *.sqlite-wal *.sqlite-shm', "", @SW_HIDE)

    ; Attente réactive (surveille la fermeture de Firefox)
    Local $elapsed = 0
    While $elapsed < $WAIT_MS
        If Not ProcessExists("firefox.exe") Then ExitLoop 2
        Sleep($SLEEP_MS)
        $elapsed += $SLEEP_MS
    WEnd

WEnd

; ================================
; SAUVEGARDE FINALE
; ================================
RunWait('robocopy "' & $RAMDISK & '" "' & $PROFILE_DISK & '" /MIR /R:0 /W:0 /XD "safebrowsing" "startupCache" /XF *.sqlite-wal *.sqlite-shm', "", @SW_HIDE)

; ================================
; Boite de dialogue autofermée 2s et désactivée après les test
; ================================
; MsgBox(64, "Terminé", "Sauvegarde finale terminée.", 2)
Exit
