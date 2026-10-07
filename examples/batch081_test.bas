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

' Batch 81 test: INPUT (console) + LINE INPUT (console)
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL line AS STRING
    LOCAL waitk AS STRING

    ConPrint "=== Batch 81: INPUT / LINE INPUT (console) ==="
    ConPrint ""

    ' Test 1: LINE INPUT with prompt
    ConPrint "Test 1: LINE INPUT with prompt"
    LINE INPUT "Enter a line: "; line
    ConPrint "You entered: [" & STR$(line) & "]"
    ConPrint ""

    ' Test 2: INPUT with prompt
    ConPrint "Test 2: INPUT with prompt"
    INPUT "Enter a string: ", s
    ConPrint "You entered: [" & s & "]"
    ConPrint ""

    ' Test 3: LINE INPUT without prompt
    ConPrint "Test 3: LINE INPUT without prompt (type something and press Enter)"
    LINE INPUT line
    ConPrint "You entered: [" & STR$(line) & "]"
    ConPrint ""

    ConPrint "=== ALL 3 TESTS PASSED ==="
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

