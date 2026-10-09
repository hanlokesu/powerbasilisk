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

' Batch 90: CBOOL — convert expression to boolean
' PB TRUE = -1 (all bits 1), FALSE = 0
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL passed AS LONG
    passed = 1

    ' Test 1: CBOOL(0) = 0 (FALSE)
    n = CBOOL(0)
    IF n <> 0 THEN ConPrint "Test 1 FAIL: CBOOL(0) = " & STR$(n) & " expected 0": passed = 0

    ' Test 2: CBOOL(1) = -1 (TRUE)
    n = CBOOL(1)
    IF n <> -1 THEN ConPrint "Test 2 FAIL: CBOOL(1) = " & STR$(n) & " expected -1": passed = 0

    ' Test 3: CBOOL(-5) = -1 (TRUE, non-zero)
    n = CBOOL(-5)
    IF n <> -1 THEN ConPrint "Test 3 FAIL: CBOOL(-5) = " & STR$(n) & " expected -1": passed = 0

    ' Test 4: CBOOL(100) = -1 (TRUE)
    n = CBOOL(100)
    IF n <> -1 THEN ConPrint "Test 4 FAIL: CBOOL(100) = " & STR$(n) & " expected -1": passed = 0

    ' Test 5: CBOOL with expression (2+3) = -1
    n = CBOOL(2 + 3)
    IF n <> -1 THEN ConPrint "Test 5 FAIL: CBOOL(2+3) = " & STR$(n) & " expected -1": passed = 0

    ' Test 6: CBOOL with expression (5-5) = 0
    n = CBOOL(5 - 5)
    IF n <> 0 THEN ConPrint "Test 6 FAIL: CBOOL(5-5) = " & STR$(n) & " expected 0": passed = 0

    ' Test 7: CBOOL can be used in IF
    IF CBOOL(42) THEN
        ' TRUE branch
    ELSE
        ConPrint "Test 7 FAIL: CBOOL(42) should be TRUE"
        passed = 0
    END IF

    ' Test 8: CBOOL(0) in IF should be FALSE
    IF CBOOL(0) THEN
        ConPrint "Test 8 FAIL: CBOOL(0) should be FALSE"
        passed = 0
    END IF

    IF passed THEN
        ConPrint "=== 8/8 TESTS PASSED ==="
    ELSE
        ConPrint "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION

FUNCTION CBOOL(BYVAL v AS LONG) AS LONG
    IF v <> 0 THEN
        FUNCTION = -1
    ELSE
        FUNCTION = 0
    END IF
END FUNCTION


