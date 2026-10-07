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

' Batch 3: PLAY SOUND / SPLIT / ARRAY SHUFFLE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL a AS STRING
    LOCAL b AS STRING
    LOCAL i AS LONG
    LOCAL sum AS LONG
    LOCAL arr() AS LONG

    PLAY SOUND 440, 60
    ConPrint "PLAYSOUND-PASS"

    s = "ABCDEF"
    SPLIT s, 2 TO a, b
    IF a = "AB" AND b = "CDEF" THEN
        ConPrint "SPLIT-PASS"
    ELSE
        ConPrint "SPLIT-FAIL [" & STR$(a) & "] [" & STR$(b) & "]"
    END IF

    REDIM arr(1 TO 5)
    FOR i = 1 TO 5
        arr(i) = i
    NEXT i
    ARRAY SHUFFLE arr()
    sum = 0
    FOR i = 1 TO 5
        sum = sum + arr(i)
    NEXT i
    IF sum = 15 THEN
        ConPrint "SHUFFLE-PASS"
    ELSE
        ConPrint "SHUFFLE-FAIL sum=" & STR$(sum)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

