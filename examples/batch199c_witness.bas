#IF (%PB_REVISION AND &H0FF00) = &H1000
    ' Compiling with PB/Win 10.x
    %MY_PBVER = 10
#ELSEIF (%PB_REVISION AND &H0FF00) = &H0900
    ' Compiling with PB/Win 9.x
    %MY_PBVER = 9
#ELSE
    ' Not PBWin (this fork, or other)
    %MY_PBVER = 0
#ENDIF
' === console emulation for dual-compiler compatibility ===
' (PBWin10 has no PRINT/#CONSOLE; this wrapper uses only official Win32 API)
DECLARE FUNCTION AllocConsole LIB "KERNEL32.DLL" ALIAS "AllocConsole" () AS LONG
DECLARE FUNCTION GetStdHandle LIB "KERNEL32.DLL" ALIAS "GetStdHandle" (BYVAL nStdHandle AS DWORD) AS LONG
DECLARE FUNCTION WriteFile LIB "KERNEL32.DLL" ALIAS "WriteFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToWrite AS DWORD, lpBytesWritten AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
DECLARE FUNCTION ReadFile LIB "KERNEL32.DLL" ALIAS "ReadFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToRead AS DWORD, lpBytesRead AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
SUB ConPrint(BYVAL s AS STRING)
    LOCAL h AS LONG
    LOCAL n AS DWORD
    h = GetStdHandle(-11)
    IF h = 0 THEN
        AllocConsole
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

' batch 199c witness - handles held in QUAD (pointer-sized on x64)
FUNCTION PBMAIN () AS LONG
    LOCAL hil AS QUAD
    LOCAL hic AS QUAD
    LOCAL cnt AS LONG
    LOCAL k AS LONG
    ConPrint "=== IMAGELIST witness (batch 199c) ==="
    IMAGELIST NEW BITMAP 16, 16, 32, 4 TO hil
    IMAGELIST NEW ICON 16, 16, 32, 4 TO hic
    ConPrint "handle bitmap list = " & STR$(hil)
    ConPrint "handle icon   list = " & STR$(hic)
    IMAGELIST GET COUNT hil TO cnt
    ConPrint "GET COUNT hil      = " & STR$(cnt)
    IMAGELIST KILL hil
    IMAGELIST KILL hic
    ConPrint "killed both; done"
    FUNCTION = 0
' Press any key to exit...
ConWaitKey
END FUNCTION

