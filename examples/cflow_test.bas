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

' Control-flow verification: one-line IF, DO WHILE, DO..UNTIL, WHILE/WEND
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL t, i AS LONG
    ' one-line IF ... THEN ... ELSE
    t = 0
    IF 1 = 1 THEN
        t = 100
    ELSE
        t = 200
    END IF
    ' one-line IF without ELSE
    IF 2 > 1 THEN t = t + 10
    ' DO WHILE ... LOOP
    i = 0
    DO WHILE i < 5
        t = t + 1
        i = i + 1
    LOOP
    ' DO ... LOOP UNTIL
    i = 0
    DO
        t = t + 2
        i = i + 1
    LOOP UNTIL i >= 3
    ' WHILE ... WEND
    i = 0
    WHILE i < 4
        t = t + 3
        i = i + 1
    WEND
    ConPrint "T=" & STR$(t)
    ' expect 100 + 10 + 5*1 + 3*2 + 4*3 = 133
    IF t = 133 THEN
        ConPrint "CFLOW-PASS"
    ELSE
        ConPrint "CFLOW-FAIL T=" & STR$(t)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


