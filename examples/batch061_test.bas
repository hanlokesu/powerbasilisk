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

' batch61_test.bas — GRAPHIC GET PPI / GET+SET POS / TEXT SIZE / GET+SET STRETCHMODE / GET+SET CAPTION
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS LONG
    LOCAL x AS LONG, y AS LONG
    LOCAL px AS SINGLE, py AS SINGLE
    LOCAL tw AS SINGLE, th AS SINGLE
    LOCAL m AS LONG
    LOCAL cap AS STRING
    LOCAL ok AS LONG
    LOCAL waitk AS STRING
    ok = 0

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp, 0

    ' 1. GET PPI
    GRAPHIC GET PPI TO x, y
    IF x > 0 AND y > 0 THEN
        ok = ok + 1
    ELSE
        ConPrint "PPI FAIL" & STR$(x) & STR$(y)
    END IF

    ' 2. SET POS then GET POS
    GRAPHIC SET POS (30, 20)
    GRAPHIC GET POS TO px, py
    IF px = 30 AND py = 20 THEN
        ok = ok + 1
    ELSE
        ConPrint "POS FAIL" & STR$(px) & STR$(py)
    END IF

    ' 3. TEXT SIZE
    GRAPHIC TEXT SIZE "Hello" TO tw, th
    IF tw > 0 AND th > 0 THEN
        ok = ok + 1
    ELSE
        ConPrint "TEXTSIZE FAIL" & STR$(tw) & STR$(th)
    END IF

    ' 4. GET STRETCHMODE (Windows default BLACKONWHITE=1)
    GRAPHIC GET STRETCHMODE TO m
    IF m = 1 THEN
        ok = ok + 1
    ELSE
        ConPrint "STRETCHMODE GET FAIL" & STR$(m)
    END IF

    ' 5. SET STRETCHMODE 3 (COLORONCOLOR) then GET
    GRAPHIC SET STRETCHMODE 3
    GRAPHIC GET STRETCHMODE TO m
    IF m = 3 THEN
        ok = ok + 1
    ELSE
        ConPrint "STRETCHMODE SET FAIL" & STR$(m)
    END IF

    ' 6. SET CAPTION then GET CAPTION (console title bridge)
    GRAPHIC SET CAPTION "Batch61-Caption-Test"
    GRAPHIC GET CAPTION TO cap
    IF INSTR(cap, "Batch61-Caption-Test") > 0 THEN
        ok = ok + 1
    ELSE
        ConPrint "CAPTION FAIL" & STR$(cap)
    END IF

    GRAPHIC DETACH

    IF ok = 6 THEN
        ConPrint "batch61: ALL PASS"
    ELSE
        ConPrint "batch61: FAILURES=" & STR$(6 - ok)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
