
#SingleInstance off

; do nothing
if !A_Args.Length {
    ExitApp(0)
}

; get log location
logFile := ""
while (!logFile || FileExist(logFile)){
    if (A_Index == 1){
        logFile := A_Temp . "\recycle_" . A_Now . ".log"
    }else{
        logFile := A_Temp . "\recycle_" . A_Now . "" . ".log"
    }
}

; scan parameter
silentMode := false
for i,c in A_Args {
    if (StrLower(c) == "/s" || StrLower(c) == "-s"){
        silentMode := true
    }
}

; recycle
for i,c in A_Args {
    if (!c){
        continue
    }
    if (FileExist(c)){
        FileRecycle(c)
        if (!silentMode){
            if (!A_LastError){
                FileAppend("Recycled : " . c . "`n", logFile)
            }else{
                FileAppend("Failed to recycle : " . c . "`n", logFile)
            }
        }
    }else{
        if (!silentMode){
            FileAppend("File/folder does not exist : " . c . "`n", logFile)
        }
    }
}

; verbose
if (!silentMode && FileExist(logFile)){
    try {
        Run("notepad.exe `"" . logFile . "`"")
    } catch {

    }
}
