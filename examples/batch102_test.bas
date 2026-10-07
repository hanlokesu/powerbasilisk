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

' Batch 102: EQV + IMP operators test
FUNCTION PBMAIN() AS LONG
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING

    ConPrint "=== Batch 102: EQV + IMP ==="

    ' Test 1: EQV - both true (-1) should be true (-1)
    a = -1: b = -1
    r = a EQV b
    ConPrint "Test 1: (-1) EQV (-1) = " & STR$(r) & " (expected -1)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 2: EQV - both false (0) should be true (-1)
    a = 0: b = 0
    r = a EQV b
    ConPrint "Test 2: 0 EQV 0 = " & STR$(r) & " (expected -1)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 3: EQV - different should be false (0)
    a = -1: b = 0
    r = a EQV b
    ConPrint "Test 3: (-1) EQV 0 = " & STR$(r) & " (expected 0)"
    IF r = 0 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 4: IMP - true implies true = true (-1)
    a = -1: b = -1
    r = a IMP b
    ConPrint "Test 4: (-1) IMP (-1) = " & STR$(r) & " (expected -1)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 5: IMP - true implies false = false (0)
    a = -1: b = 0
    r = a IMP b
    ConPrint "Test 5: (-1) IMP 0 = " & STR$(r) & " (expected 0)"
    IF r = 0 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 6: IMP - false implies anything = true (-1)
    a = 0: b = 0
    r = a IMP b
    ConPrint "Test 6: 0 IMP 0 = " & STR$(r) & " (expected -1)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 7: IMP - false implies true = true (-1)
    a = 0: b = -1
    r = a IMP b
    ConPrint "Test 7: 0 IMP (-1) = " & STR$(r) & " (expected -1)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 8: EQV with numbers (bitwise)
    a = 5: b = 5
    r = a EQV b
    ConPrint "Test 8: 5 EQV 5 = " & STR$(r) & " (expected -1, all bits same)"
    IF r = -1 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ConPrint ""
    ConPrint "=== Batch 102 tests complete ==="
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


