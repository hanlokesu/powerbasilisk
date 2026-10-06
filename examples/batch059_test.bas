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

' PowerBasilisk Enhanced - batch59_test.bas
' GRAPHIC SET PIXEL / GET SIZE / SET+GET TEXTALIGN (batch 59)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL px AS LONG
    LOCAL w AS LONG
    LOCAL h AS LONG
    LOCAL ta AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp

    GRAPHIC SET PIXEL (20, 20), 16711680
    GRAPHIC GET PIXEL (20, 20) TO px
    ConPrint "OK: pixel=" & STR$(px)
    IF px = 16711680 THEN
        ConPrint "OK: set pixel red"
    ELSE
        ConPrint "FAIL: pixel color wrong"
        INCR fails
    END IF

    GRAPHIC GET SIZE TO w, h
    ConPrint "OK: size=" & STR$(w) & "x" & STR$(h)
    IF w = 100 AND h = 50 THEN
        ConPrint "OK: size matches bitmap"
    ELSE
        ConPrint "FAIL: size wrong"
        INCR fails
    END IF

    GRAPHIC SET TEXTALIGN (2)
    GRAPHIC GET TEXTALIGN TO ta
    ConPrint "OK: textalign=" & STR$(ta)
    IF ta = 2 THEN
        ConPrint "OK: textalign round-trip"
    ELSE
        ConPrint "FAIL: textalign wrong"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        ConPrint "batch59: ALL PASS"
    ELSE
        ConPrint "batch59: FAILURES=" & STR$(fails)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
