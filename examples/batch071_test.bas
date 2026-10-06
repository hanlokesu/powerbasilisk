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

' PowerBasilisk Enhanced - Batch 71 Test: XPRINT TEXT SIZE / GET CLIENT / GET CANVAS / WRAP / WORDWRAP / OVERLAP
FUNCTION PBMAIN() AS LONG
    LOCAL tw AS LONG, th AS LONG
    LOCAL cw AS LONG, ch AS LONG
    LOCAL cw2 AS LONG, ch2 AS LONG
    LOCAL wrap AS LONG, ww AS LONG, ov AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 71: XPRINT text size + client + wrap ==="

    XPRINT ATTACH DEFAULT

    XPRINT TEXT SIZE "Hello World" TO tw, th
    ConPrint "TEXT SIZE:" & STR$(tw) & "x" & STR$(th)
    IF tw = 0 OR th = 0 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT GET CLIENT TO cw, ch
    ConPrint "GET CLIENT:" & STR$(cw) & "x" & STR$(ch)
    IF cw = 0 OR ch = 0 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT GET CANVAS TO cw2, ch2
    ConPrint "GET CANVAS:" & STR$(cw2) & "x" & STR$(ch2)
    IF cw2 <> cw OR ch2 <> ch THEN fails = fails + 1 : ConPrint "  FAIL: canvas != client"

    XPRINT SET WRAP 1
    XPRINT GET WRAP TO wrap
    ConPrint "SET/GET WRAP:" & STR$(wrap)
    IF wrap <> 1 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT SET WORDWRAP 1
    XPRINT GET WORDWRAP TO ww
    ConPrint "SET/GET WORDWRAP:" & STR$(ww)
    IF ww <> 1 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT SET OVERLAP 50
    XPRINT GET OVERLAP TO ov
    ConPrint "SET/GET OVERLAP:" & STR$(ov)
    IF ov <> 50 THEN fails = fails + 1 : ConPrint "  FAIL"

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

