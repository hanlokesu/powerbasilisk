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

' Batch 12: ON GOTO / ON GOSUB
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL i AS LONG
    LOCAL r AS LONG
    r = 0

    ' ON GOTO: select label by index (1-based)
    i = 2
    ON i GOTO one, two, three
    r = r + 100
    GOTO done
one:
    r = r + 1
    GOTO done
two:
    r = r + 2
    GOTO done
three:
    r = r + 3
done:
    IF r = 2 THEN
        ConPrint "ON-GOTO-PASS"
    ELSE
        ConPrint "ON-GOTO-FAIL r=" & STR$(r)
    END IF

    ' ON GOTO: out of range falls through
    r = 0
    i = 5
    ON i GOTO o1, o2
    r = r + 50
    GOTO odone
o1:
    r = r + 1
    GOTO odone
o2:
    r = r + 2
odone:
    IF r = 50 THEN
        ConPrint "ON-GOTO-RANGE-PASS"
    ELSE
        ConPrint "ON-GOTO-RANGE-FAIL r=" & STR$(r)
    END IF

    ' ON GOSUB: select subroutine by index
    r = 0
    i = 3
    ON i GOSUB s1, s2, s3
    IF r = 3 THEN
        ConPrint "ON-GOSUB-PASS"
    ELSE
        ConPrint "ON-GOSUB-FAIL r=" & STR$(r)
    END IF
    GOTO gdone
s1:
    r = r + 1
    RETURN
s2:
    r = r + 2
    RETURN
s3:
    r = r + 3
    RETURN
gdone:

    ' ON GOSUB: out of range falls through
    r = 0
    i = 0
    ON i GOSUB t1, t2
    IF r = 0 THEN
        ConPrint "ON-GOSUB-RANGE-PASS"
    ELSE
        ConPrint "ON-GOSUB-RANGE-FAIL r=" & STR$(r)
    END IF
    GOTO tdone
t1:
    r = r + 1
    RETURN
t2:
    r = r + 2
    RETURN
tdone:
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


