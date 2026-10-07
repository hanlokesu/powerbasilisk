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

' equate_demo.bas   PB  string equates 18 
'  equate  equate_result.txt
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG

    f = FREEFILE
    OPEN "equate_result.txt" FOR OUTPUT AS #f

    PRINT #f, "NUL=" + $NUL
    PRINT #f, "BEL=" + $BEL
    PRINT #f, "BS=" + $BS
    PRINT #f, "TAB=" + $TAB
    PRINT #f, "LF=" + $LF
    PRINT #f, "VT=" + $VT
    PRINT #f, "FF=" + $FF
    PRINT #f, "CR=" + $CR
    PRINT #f, "CRLF=" + $CRLF
    PRINT #f, "EOF=" + $EOF
    PRINT #f, "ESC=" + $ESC
    PRINT #f, "SPC=" + $SPC
    PRINT #f, "DQ=" + $DQ
    PRINT #f, "DQ2=" + $DQ2
    PRINT #f, "SQ=" + $SQ
    PRINT #f, "SQ2=" + $SQ2
    PRINT #f, "QCQ=" + $QCQ
    PRINT #f, "WHITESPACE=" + $WHITESPACE

    ' $CRLF 
    PRINT #f, "LINE1" + $CRLF + "LINE2"

    CLOSE #f

    FUNCTION = 0
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


