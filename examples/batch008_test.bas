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

' Batch 8: ARRAY DELETE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a() AS LONG
    LOCAL i AS LONG
    LOCAL ok AS LONG

    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i

    ARRAY DELETE a(2)
    ' now 10,30,40,50 (tail zeroed)
    IF a(1) = 10 AND a(2) = 30 AND a(3) = 40 AND a(4) = 50 THEN
        ConPrint "ARRAY-DELETE-PASS"
    ELSE
        ConPrint "ARRAY-DELETE-FAIL a(1)=" & STR$(a(1)) & " a(2)=" & STR$(a(2)) & " a(3)=" & STR$(a(3)) & " a(4)=" & STR$(a(4))
    END IF

    ARRAY DELETE a(1) FOR 2
    ' now 40,50
    IF a(1) = 40 AND a(2) = 50 THEN
        ConPrint "ARRAY-DELETE-FOR-PASS"
    ELSE
        ConPrint "ARRAY-DELETE-FOR-FAIL a(1)=" & STR$(a(1)) & " a(2)=" & STR$(a(2))
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

