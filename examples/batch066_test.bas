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

' PowerBasilisk Enhanced - Batch 66 test
' GRAPHIC SET FIXED + GRAPHIC SET FONT
FUNCTION PBMAIN() AS LONG
    LOCAL hBmp AS LONG
    LOCAL hFont AS QUAD
    LOCAL ok AS LONG
    LOCAL waitk AS STRING
    ok = 0

    GRAPHIC BITMAP NEW 100, 50 TO hBmp
    GRAPHIC ATTACH hBmp

    ' SET FIXED (no-arg, restores fixed mode)
    GRAPHIC SET FIXED
    ok = ok + 1

    ' FONT NEW returns a handle via TO clause
    FONT NEW "Arial", 12, 0, 0, 0, 0 TO hFont
    IF hFont <> 0 THEN
        ok = ok + 1
    ELSE
        ConPrint "FAIL
        FONT NEW returned 0" END IF
    END IF

    ' SET FONT selects the font into the graphic DC
    GRAPHIC SET FONT hFont
    ok = ok + 1

    ' Draw text with the selected font (should not crash)
    GRAPHIC PRINT "Hello"
    ok = ok + 1

    ' FONT END deletes the font
    FONT END hFont
    ok = ok + 1

    IF ok = 5 THEN
        ConPrint "ALL PASS (5/5)"
    ELSE
        ConPrint "FAIL: " & STR$(ok)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
