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

' Batch 6: BIT / BIT SET/RESET/TOGGLE / BIT CALC / PROCESS PRIORITY
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL p AS LONG

    f = 5
    IF BIT(f, 0) = 1 AND BIT(f, 2) = 1 AND BIT(f, 1) = 0 THEN
        ConPrint "BIT-FUNC-PASS"
    ELSE
        ConPrint "BIT-FUNC-FAIL"
    END IF

    BIT SET f, 1
    IF f = 7 THEN
        ConPrint "BIT-SET-PASS"
    ELSE
        ConPrint "BIT-SET-FAIL f=" & STR$(f)
    END IF

    BIT RESET f, 0
    IF f = 6 THEN
        ConPrint "BIT-RESET-PASS"
    ELSE
        ConPrint "BIT-RESET-FAIL f=" & STR$(f)
    END IF

    BIT TOGGLE f, 2
    IF f = 2 THEN
        ConPrint "BIT-TOGGLE-PASS"
    ELSE
        ConPrint "BIT-TOGGLE-FAIL f=" & STR$(f)
    END IF

    f = 0
    BIT CALC f, 3, 1
    IF f = 8 THEN
        ConPrint "BIT-CALC-PASS"
    ELSE
        ConPrint "BIT-CALC-FAIL f=" & STR$(f)
    END IF

    PROCESS GET PRIORITY TO p
    IF p > 0 THEN
        ConPrint "PROCESS-GET-PASS p=" & STR$(p)
    ELSE
        ConPrint "PROCESS-GET-FAIL p=" & STR$(p)
    END IF

    PROCESS SET PRIORITY 32
    PROCESS GET PRIORITY TO p
    IF p = 32 THEN
        ConPrint "PROCESS-SET-PASS"
    ELSE
        ConPrint "PROCESS-SET-FAIL p=" & STR$(p)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


