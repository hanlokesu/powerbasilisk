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

' PowerBasilisk Enhanced - Batch 68 Test: XPRINT ATTACH/CLOSE/GET PPI/GET SIZE/GET DC
' Uses screen DC as fallback when no printer is available (CI-friendly)
FUNCTION PBMAIN() AS LONG
    LOCAL hdc AS LONG
    LOCAL hdc2 AS QUAD
    LOCAL px AS LONG
    LOCAL py AS QUAD
    LOCAL pw AS QUAD
    LOCAL ph AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 68: XPRINT ==="

    ' 1. ATTACH DEFAULT (falls back to screen DC if no printer)
    XPRINT ATTACH DEFAULT
    ConPrint "XPRINT ATTACH DEFAULT: done"

    ' 2. GET DC — should be non-zero
    XPRINT GET DC TO hdc
    ConPrint "XPRINT GET DC: hdc=" & STR$(hdc)
    IF hdc = 0 THEN
        ConPrint "  FAIL: hdc is zero"
        fails = fails + 1
    ELSE
        ConPrint "  PASS: hdc non-zero"
    END IF

    ' 3. GET PPI — screen is typically 96 DPI
    XPRINT GET PPI TO px, py
    ConPrint "XPRINT GET PPI: x=" & STR$(px) & " y=" & STR$(py)
    IF px = 0 OR py = 0 THEN
        ConPrint "  FAIL: PPI is zero"
        fails = fails + 1
    ELSE
        ConPrint "  PASS: PPI non-zero"
    END IF

    ' 4. GET SIZE — physical width/height in pixels
    XPRINT GET SIZE TO pw, ph
    ConPrint "XPRINT GET SIZE: w=" & STR$(pw) & " h=" & STR$(ph)
    IF pw = 0 OR ph = 0 THEN
        ConPrint "  FAIL: SIZE is zero"
        fails = fails + 1
    ELSE
        ConPrint "  PASS: SIZE non-zero"
    END IF

    ' 5. CLOSE
    XPRINT CLOSE
    ConPrint "XPRINT CLOSE: done"

    ' 6. GET DC after CLOSE — should be zero
    XPRINT GET DC TO hdc2
    ConPrint "XPRINT GET DC (after close): hdc=" & STR$(hdc2)
    IF hdc2 <> 0 THEN
        ConPrint "  FAIL: hdc should be zero after close"
        fails = fails + 1
    ELSE
        ConPrint "  PASS: hdc zero after close"
    END IF

    ConPrint "=== Result: "
    IF fails = 0 THEN
        ConPrint "ALL PASS (5/5)"
    ELSE
        ConPrint STR$(fails) & " FAILED"
    END IF

    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

