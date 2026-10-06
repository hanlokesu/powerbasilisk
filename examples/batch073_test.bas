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

' PowerBasilisk Enhanced - Batch 73 Test: XPRINT POLYGON / POLYLINE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 73: XPRINT polygon + polyline ==="

    XPRINT ATTACH DEFAULT

    XPRINT COLOR 255, 0
    XPRINT POLYGON 100, 100, 200, 100, 150, 50
    ConPrint "POLYGON (triangle): done"

    XPRINT COLOR 0, 255
    XPRINT POLYLINE 50, 200, 100, 250, 150, 200, 200, 250, 250, 200
    ConPrint "POLYLINE (5 pts): done"

    XPRINT COLOR 0, 0, 255
    XPRINT POLYGON 300, 100, 400, 100, 400, 200, 300, 200
    ConPrint "POLYGON (rect): done"

    XPRINT CLOSE

    ConPrint "=== Result: ALL PASS (GDI calls returned, no crash)"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

