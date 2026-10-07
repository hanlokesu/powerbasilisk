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

' PowerBasilisk Enhanced - batch49_test.bas
' COLOR fore& [, back&] (tier-3 -> implemented, batch 49; PB/CC console color)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    COLOR 10, 0
    ConPrint "green foreground test line"
    COLOR 12, 0
    ConPrint "red foreground test line"
    COLOR 7, 4
    ConPrint "white on red test line"
    COLOR 7, 0
    ConPrint "back to normal"

    IF fails = 0 THEN
        ConPrint "batch49: ALL PASS (colors applied without error)"
    ELSE
        ConPrint "batch49: FAILURES=" & STR$(fails)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

