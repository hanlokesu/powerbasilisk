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

' Batch 10: ARRAY SCAN
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a() AS LONG
    LOCAL i AS LONG
    LOCAL idx AS LONG
    LOCAL s() AS STRING

    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i

    ARRAY SCAN a(), = 30, TO idx
    IF idx = 3 THEN
        ConPrint "ARRAY-SCAN-EQ-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "ARRAY-SCAN-EQ-FAIL idx=" & STR$(idx)
    END IF

    ARRAY SCAN a(), > 40, TO idx
    IF idx = 5 THEN
        ConPrint "ARRAY-SCAN-GT-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "ARRAY-SCAN-GT-FAIL idx=" & STR$(idx)
    END IF

    ARRAY SCAN a(), <> 10, TO idx
    IF idx = 2 THEN
        ConPrint "ARRAY-SCAN-NEQ-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "ARRAY-SCAN-NEQ-FAIL idx=" & STR$(idx)
    END IF

    ARRAY SCAN a(), = 99, TO idx
    IF idx = 0 THEN
        ConPrint "ARRAY-SCAN-NONE-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "ARRAY-SCAN-NONE-FAIL idx=" & STR$(idx)
    END IF

    REDIM s(1 TO 3)
    s(1) = "apple"
    s(2) = "banana"
    s(3) = "cherry"
    ARRAY SCAN s(), = "banana", TO idx
    IF idx = 2 THEN
        ConPrint "ARRAY-SCAN-STR-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "ARRAY-SCAN-STR-FAIL idx=" & STR$(idx)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


