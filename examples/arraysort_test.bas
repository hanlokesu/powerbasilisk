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

' ARRAY SORT verification (LONG + STRING arrays)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL i, ok AS LONG
    LOCAL arr() AS LONG
    LOCAL sarr() AS STRING
    REDIM arr(1 TO 6)
    arr(1) = 42: arr(2) = 7: arr(3) = 99: arr(4) = -3: arr(5) = 15: arr(6) = 0
    ARRAY SORT arr()
    ok = 1
    FOR i = 2 TO 6
        IF arr(i) < arr(i - 1) THEN ok = 0
    NEXT i
    IF arr(1) <> -3 OR arr(6) <> 99 THEN ok = 0
    REDIM sarr(1 TO 4)
    sarr(1) = "pear"
    sarr(2) = "apple"
    sarr(3) = "cherry"
    sarr(4) = "banana"
    ARRAY SORT sarr()
    IF sarr(1) <> "apple" OR sarr(4) <> "pear" THEN ok = 0
    IF ok = 1 THEN
        ConPrint "SORT-PASS"
    ELSE
        ConPrint "SORT-FAIL"
        FOR i = 1 TO 6: ConPrint "arr(" & STR$(i) & ")=" & STR$(arr(i)): NEXT i
        FOR i = 1 TO 4: ConPrint "sarr(" & STR$(i) & ")=" & sarr(i): NEXT i
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


