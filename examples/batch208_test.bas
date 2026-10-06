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

'=====================================================================
' batch208_test.bas - batch 208: module-level UDT still compiles
'---------------------------------------------------------------------
' Batch 208 made a bare `TYPE` inside a procedure body a loud compile error
' instead of silently skipping the line, and its own reverse validation was that
' a *module-level* TYPE ... END TYPE block keeps working.  That probe lived in
' the work directory; this sample puts the same assertion in the corpus so the
' release gate runs it on every batch.
'
' The negative half of the batch (a bare TYPE in a body must fail the build) is
' a compile-time assertion and cannot appear here - a sample that does not
' compile cannot be a sample.  It stays in the batch note.
'
' Asserts: a module-level UDT declares, fields assign and read back.
'=====================================================================
TYPE Point
    x AS LONG
    y AS LONG
END TYPE

FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL p AS Point
    p.x = 3
    p.y = 4
    ConPrint "point = " & STR$(p.x) & " $TAB " & STR$(p.y)
    IF p.x <> 3 THEN
        fail = fail + 1
    END IF
    IF p.y <> 4 THEN
        fail = fail + 1
    END IF
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
ConWaitKey
END FUNCTION

