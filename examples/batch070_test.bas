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

' PowerBasilisk Enhanced - Batch 70 Test: XPRINT ARC/ELLIPSE/PIE/FONT/MIX/STRETCHMODE
FUNCTION PBMAIN() AS LONG
    LOCAL attached AS LONG
    LOCAL mix AS LONG
    LOCAL sm AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 70: XPRINT shapes + font + mix ==="

    XPRINT ATTACH DEFAULT
    XPRINT GET ATTACH TO attached
    IF attached <> 1 THEN fails = fails + 1 : ConPrint "FAIL: attach"

    XPRINT SET COLOR 255
    XPRINT ARC 10, 10, 200, 200, 10, 10, 200, 200
    ConPrint "ARC: done"

    XPRINT ELLIPSE 50, 50, 250, 200
    ConPrint "ELLIPSE: done"

    XPRINT PIE 10, 10, 300, 300, 10, 10, 300, 10
    ConPrint "PIE: done"

    XPRINT SET FONT "Arial", 24, 1, 0
    XPRINT SET POS 50, 350
    XPRINT PRINT "Bold 24pt Arial"
    ConPrint "SET FONT: done"

    XPRINT SET MIX 11
    XPRINT GET MIX TO mix
    ConPrint "SET/GET MIX:" & STR$(mix)
    IF mix <> 11 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT SET STRETCHMODE 3
    XPRINT GET STRETCHMODE TO sm
    ConPrint "SET/GET STRETCHMODE:" & STR$(sm)
    IF sm <> 3 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT CLOSE

    ConPrint "=== Result: "
    IF fails = 0 THEN
        ConPrint "ALL PASS"
    ELSE
        ConPrint STR$(fails) & " FAILED"
    END IF

    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


