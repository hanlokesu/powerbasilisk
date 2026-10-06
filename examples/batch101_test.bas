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

' Batch 101: ACODE$ test
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL r AS STRING
    LOCAL waitk AS STRING

    ConPrint "=== Batch 101: ACODE$ ==="

    ' Test 1: ACODE$ with normal string
    s = "Hello World"
    r = ACODE$(s)
    ConPrint "Test 1: ACODE$('Hello World') = [" & r & "]"
    IF r = "Hello World" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 2: ACODE$ with empty string
    s = ""
    r = ACODE$(s)
    ConPrint "Test 2: ACODE$('') = [" & r & "]"
    IF r = "" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ' Test 3: ACODE$ with special characters
    s = "Test 123 !@#"
    r = ACODE$(s)
    ConPrint "Test 3: ACODE$('Test 123 !@#') = [" & r & "]"
    IF r = "Test 123 !@#" THEN
        ConPrint "  PASS"
    ELSE
        ConPrint "  FAIL"
    END IF

    ConPrint ""
    ConPrint "=== Batch 101 tests complete ==="
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

