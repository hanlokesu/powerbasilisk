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

' Batch 103: #-directives (DEBUG/OPTION/RESOURCE)
#DEBUG BOUNDS
#DEBUG DISPLAY
#DEBUG ERROR
#DEBUG NUMERIC
#OPTION EXPLICIT
#RESOURCE "test.res"

FUNCTION PBMAIN() AS LONG
    LOCAL msg AS STRING
    LOCAL waitk AS STRING
    msg = "All 6 #-directives accepted without error!"
    ConPrint "  MSGBOX skipped (headless): " & STR$(msg)
    ConPrint "Testing #-directives..."
    ConPrint "  #DEBUG BOUNDS  - OK"
    ConPrint "  #DEBUG DISPLAY - OK"
    ConPrint "  #DEBUG ERROR   - OK"
    ConPrint "  #DEBUG NUMERIC - OK"
    ConPrint "  #OPTION        - OK"
    ConPrint "  #RESOURCE      - OK"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

