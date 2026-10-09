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

' Coverage audit verification: LET/IF/FOR/SELECT/VAL/ASC/MID$/FUNCTION
FUNCTION Add2(x AS LONG) AS LONG
    FUNCTION = x + 2
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a, b, i, t AS LONG
    LOCAL s AS STRING
    ' LET (implicit) + IF/END IF
    a = 1
    IF a = 1 THEN
        b = 2
    ELSE
        b = 3
    END IF
    t = b
    ' FOR / NEXT
    FOR i = 1 TO 3
        t = t + i
    NEXT i
    ' SELECT CASE / END SELECT
    SELECT CASE a
        CASE 1
            t = t + 100
        CASE ELSE
            t = 0
    END SELECT
    ' VAL / ASC / MID$ (function form)
    s = "abc123"
    t = t + VAL("45") + ASC("A") + VAL(MID$(s, 4, 3))
    ' user FUNCTION
    t = t + Add2(10)
    ConPrint "T=" & STR$(t)
    IF t = 353 THEN
        ConPrint "AUDIT-PASS"
    ELSE
        ConPrint "AUDIT-FAIL T=" & STR$(t)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


