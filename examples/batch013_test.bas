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

' Batch 13: CLIPBOARD SET/GET TEXT, RESET, INPUT FLUSH
OPTION EXPLICIT
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL rc AS LONG

    CLIPBOARD SET TEXT "hello clipboard", rc
    IF rc = 0 THEN
        ConPrint "CLIP-SET-PASS"
    ELSE
        ConPrint "CLIP-SET-FAIL rc=" & STR$(rc)
    END IF

    CLIPBOARD GET TEXT TO s
    IF s = "hello clipboard" THEN
        ConPrint "CLIP-GET-PASS"
    ELSE
        ConPrint "CLIP-GET-FAIL [ " & STR$(s) & " ]"
    END IF

    CLIPBOARD RESET, rc
    CLIPBOARD GET TEXT TO s
    IF s = "" THEN
        ConPrint "CLIP-RESET-PASS"
    ELSE
        ConPrint "CLIP-RESET-FAIL [ " & STR$(s) & " ]"
    END IF

    INPUT FLUSH
    ConPrint "INPUT-FLUSH-PASS"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

