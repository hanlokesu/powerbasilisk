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

' GET/PUT binary file I/O + list declarations (LOCAL a, b AS TYPE)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f, a, b AS LONG
    LOCAL q1, q2 AS QUAD
    f = FREEFILE
    OPEN "getput_test.dat" FOR BINARY AS #f
    a = 123456789
    PUT #f, 1, a
    b = 0
    GET #f, 1, b
    q1 = 987654321012345
    PUT #f, 9, q1
    q2 = 0
    GET #f, 9, q2
    CLOSE #f
    KILL "getput_test.dat"
    IF b = 123456789 AND q2 = 987654321012345 THEN
        ConPrint "GETPUT-PASS b=" & STR$(b) & " q=" & STR$(q2)
    ELSE
        ConPrint "GETPUT-FAIL b=" & STR$(b) & " q=" & STR$(q2)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

