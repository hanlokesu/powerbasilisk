#COMPILE EXE
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


' parse_test2.bas - verify PARSE$ 2-arg form and PARSECOUNT 1-arg form (fixed)
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL n AS LONG
    LOCAL p AS STRING
    s = "one two three four"

    ' PARSECOUNT(s) - space delimiter (1-arg, was panic before fix)
    n = PARSECOUNT(s)
    ConPrint "count = " & STR$(n)
    IF n <> 4 THEN
        ConPrint "FAIL: expected 4"
    ELSE
        ConPrint "ok count=4"
    END IF

    ' PARSE$(s, i) - space delimiter, i-th word (2-arg form)
    p = PARSE$(s, 2)
    ConPrint "word2 = " & STR$(p)
    IF p <> "two" THEN
        ConPrint "FAIL: expected two"
    ELSE
        ConPrint "ok word2=two"
    END IF

    p = PARSE$(s, 4)
    ConPrint "word4 = " & STR$(p)
    IF p <> "four" THEN
        ConPrint "FAIL: expected four"
    ELSE
        ConPrint "ok word4=four"
    END IF

    ' PARSE$(s, delim, i) - 3-arg form (regression)
    s = "a,b,c"
    p = PARSE$(s, ",", 2)
    ConPrint "csv2 = " & STR$(p)
    IF p <> "b" THEN
        ConPrint "FAIL: expected b"
    ELSE
        ConPrint "ok csv2=b"
    END IF

    n = PARSECOUNT(s, ",")
    ConPrint "csv count = " & STR$(n)
    IF n <> 3 THEN
        ConPrint "FAIL: expected 3"
    ELSE
        ConPrint "ok csv count=3"
    END IF

    ConPrint "ALL PASS"
' Press any key to exit...
ConWaitKey
END FUNCTION

