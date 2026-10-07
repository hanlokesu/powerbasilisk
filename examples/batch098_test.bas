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

' Batch 98: ISWIN + MCASE$ test
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    LOCAL result AS LONG

    ConPrint "=== Batch 98: ISWIN + MCASE$ ==="

    ' Test 1: MCASE$ basic
    s = MCASE$("hello world")
    ConPrint "Test 1: MCASE$('hello world') = [" & s & "]"
    IF s = "Hello World" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 2: MCASE$ with mixed case and punctuation
    s = MCASE$("Cats aren't AL.WAYS good.")
    ConPrint "Test 2: MCASE$('Cats aren''t AL.WAYS good.') = [" & s & "]"
    IF s = "Cats Aren'T Al.Ways Good." THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 3: MCASE$ all uppercase
    s = MCASE$("HELLO WORLD")
    ConPrint "Test 3: MCASE$('HELLO WORLD') = [" & s & "]"
    IF s = "Hello World" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 4: MCASE$ empty string
    s = MCASE$("")
    ConPrint "Test 4: MCASE$('') = [" & s & "]"
    IF s = "" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 5: ISWIN with null handle (should return 0 = FALSE)
    result = ISWIN(0)
    ConPrint "Test 5: ISWIN(0) = " & STR$(result) & " (expected 0)"
    IF result = 0 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 6: ISWIN with invalid handle (should return 0 = FALSE)
    result = ISWIN(999999)
    ConPrint "Test 6: ISWIN(999999) = " & STR$(result) & " (expected 0)"
    IF result = 0 THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ConPrint ""
    ConPrint "=== Batch 98 tests complete ==="
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


