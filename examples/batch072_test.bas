#IF %DEF(%PB_REVISION)
    #IF (%PB_REVISION AND &H0FF00) = &H1000
        %MY_PBVER = 10
    #ELSE
        %MY_PBVER = 0
    #ENDIF
#ELSE
    %MY_PBVER = 0
#ENDIF

' --- PBWin10 stub branch: this sample exercises PowerBasilisk-only ---
'     syntax that official PBWin10 does not provide; it compiles but
'     does nothing here.  The fork branch (#ELSE) is the real test.
#IF %MY_PBVER = 10
FUNCTION PBMAIN() AS LONG
    ' PowerBasilisk-only sample: PBWin10 stub (compiles, does nothing).
END FUNCTION
#ELSE

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

' PowerBasilisk Enhanced - Batch 72 Test: XPRINT CLIP/SCALE/LINES/CELL SIZE/CHR SIZE/COPY
FUNCTION PBMAIN() AS LONG
    LOCAL cx1 AS LONG, cy1 AS LONG, cx2 AS LONG, cy2 AS LONG
    LOCAL sw AS LONG, sh AS LONG
    LOCAL lines AS LONG
    LOCAL cw AS LONG, ch AS LONG
    LOCAL chrw AS LONG, chrh AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 72: XPRINT clip + scale + metrics ==="

    XPRINT ATTACH DEFAULT

    XPRINT SET CLIP 10, 10, 500, 500
    XPRINT GET CLIP TO cx1, cy1, cx2, cy2
    ConPrint "GET CLIP:" & STR$(cx1) & STR$(cy1) & STR$(cx2) & STR$(cy2)
    IF cx2 <= cx1 OR cy2 <= cy1 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT SCALE 1000, 1000
    XPRINT GET SCALE TO sw, sh
    ConPrint "GET SCALE:" & STR$(sw) & STR$(sh)
    IF sw <> 1000 OR sh <> 1000 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT GET LINES TO lines
    ConPrint "GET LINES:" & STR$(lines)
    IF lines = 0 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT CELL SIZE TO cw, ch
    ConPrint "CELL SIZE:" & STR$(cw) & "x" & STR$(ch)
    IF cw = 0 OR ch = 0 THEN fails = fails + 1 : ConPrint "  FAIL"

    XPRINT CHR SIZE TO chrw, chrh
    ConPrint "CHR SIZE:" & STR$(chrw) & "x" & STR$(chrh)
    IF chrw <> cw OR chrh <> ch THEN fails = fails + 1 : ConPrint "  FAIL: chr != cell"

    XPRINT COPY 0, 0, 100, 100, 0, 0
    ConPrint "COPY: done"

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



#ENDIF
