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

' Batch 86: TRUNC function - truncate toward zero
FUNCTION PBMAIN() AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    ConPrint "=== Batch 86: TRUNC function ==="

    ' Test 1: positive fractional
    r = TRUNC(3.7)
    ConPrint "Test 1: TRUNC(3.7) =" & STR$(r)
    IF r = 3 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected 3)"
    END IF

    ' Test 2: negative fractional (trunc toward zero, NOT floor)
    r = TRUNC(-3.7)
    ConPrint "Test 2: TRUNC(-3.7) =" & STR$(r)
    IF r = -3 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected -3, trunc toward zero)"
    END IF

    ' Test 3: exact integer
    r = TRUNC(3.0)
    ConPrint "Test 3: TRUNC(3.0) =" & STR$(r)
    IF r = 3 THEN
        ConPrint "  PASS"
        pass = pass + 1
    ELSE
        ConPrint "  FAIL (expected 3)"
    END IF

    ' Test 4: small positive
    r = TRUNC(0.5)
    ConPrint "Test 4: TRUNC(0.5) =" & STR$(r)
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

FUNCTION TRUNC(BYVAL v AS DOUBLE) AS LONG
    IF v >= 0 THEN
        FUNCTION = INT(v)
    ELSE
        FUNCTION = -INT(-v)
    END IF
END FUNCTION

