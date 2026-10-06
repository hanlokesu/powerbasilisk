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

' Batch 85: FLOOR function - round down to nearest integer
FUNCTION PBMAIN() AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    ConPrint "=== Batch 85: FLOOR function ==="

    ' Test 1: positive fractional
    r = FLOOR(3.7)
    ConPrint "Test 1: FLOOR(3.7) =" & STR$(r)
    IF r = 3 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected 3)"
    END IF

    ' Test 2: negative fractional (floor goes more negative)
    r = FLOOR(-3.7)
    ConPrint "Test 2: FLOOR(-3.7) =" & STR$(r)
    IF r = -4 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected -4)"
    END IF

    ' Test 3: exact integer
    r = FLOOR(3.0)
    ConPrint "Test 3: FLOOR(3.0) =" & STR$(r)
    IF r = 3 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected 3)"
    END IF

    ' Test 4: small positive
    r = FLOOR(0.5)
    ConPrint "Test 4: FLOOR(0.5) =" & STR$(r)
    IF r = 0 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected 0)"
    END IF

    ConPrint "=== " & STR$(pass) & "/4 TESTS PASSED ==="
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

FUNCTION FLOOR(BYVAL v AS DOUBLE) AS LONG
    LOCAL i AS LONG
    i = INT(v)
    IF v < i THEN i = i - 1
    FUNCTION = i
END FUNCTION

