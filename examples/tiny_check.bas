' === console emulation for dual-compiler compatibility ===
' (PBWin10 has no PRINT/#CONSOLE; this wrapper uses only official Win32 API)
DECLARE FUNCTION AllocConsole LIB "KERNEL32.DLL" ALIAS "AllocConsole" () AS LONG
DECLARE FUNCTION AttachConsole LIB "KERNEL32.DLL" ALIAS "AttachConsole" (BYVAL dwProcessId AS DWORD) AS LONG
DECLARE FUNCTION GetStdHandle LIB "KERNEL32.DLL" ALIAS "GetStdHandle" (BYVAL nStdHandle AS DWORD) AS LONG
DECLARE FUNCTION WriteFile LIB "KERNEL32.DLL" ALIAS "WriteFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToWrite AS DWORD, lpBytesWritten AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
DECLARE FUNCTION ReadFile LIB "KERNEL32.DLL" ALIAS "ReadFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToRead AS DWORD, lpBytesRead AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
SUB ConPrint(BYVAL s AS STRING)
    LOCAL h AS LONG
    LOCAL n AS DWORD
    h = GetStdHandle(-11)
    IF h = 0 THEN
        IF AttachConsole(-1) = 0 THEN AllocConsole
        h = GetStdHandle(-11)
    END IF
    IF h <> 0 THEN
        WriteFile h, BYVAL STRPTR(s), LEN(s), n, 0
    END IF
END SUB
SUB ConWaitKey()
    LOCAL h AS LONG
    LOCAL c AS STRING * 1
    LOCAL n AS DWORD
    h = GetStdHandle(-10)
    IF h <> 0 THEN
        ReadFile h, c, 1, n, 0
    END IF
END SUB

' tiny_check.bas  
' BEEP, SWAP, SLEEP, MKDIR, RMDIR, RANDOMIZE
'  tiny_result.txt MSGBOX

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL p AS STRING
    LOCAL f AS LONG
    LOCAL ok AS LONG

    ok = 1

    ' 1. RANDOMIZE  
    RANDOMIZE 42

    ' 2. MKDIR  
    p = "tiny_demo_dir"
    MKDIR p
    IF ISFILE(p) = 0 THEN ok = 0

    ' 3. SWAP  
    a = 111
    b = 222
    SWAP a, b
    IF a <> 222 OR b <> 111 THEN ok = 0

    ' 4. BEEP  
    BEEP

    ' 5. SLEEP   300ms
    SLEEP 300

    ' 6. RMDIR  
    RMDIR p
    IF ISFILE(p) <> 0 THEN ok = 0

    ' 
    f = FREEFILE
    OPEN "tiny_result.txt" FOR OUTPUT AS #f
    IF ok = 1 THEN
        PRINT #f, "ALL OK: swap=" + STR$(a) + " $TAB " + STR$(b) + " rand+mkdir+beep+sleep+rmdir ran"
    ELSE
        PRINT #f, "FAILED: a=" + STR$(a) + " b=" + STR$(b)
    END IF
    CLOSE #f

    FUNCTION = 0
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


