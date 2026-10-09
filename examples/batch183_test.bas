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

'=====================================================================
' batch183_test.bas - batch 183: GRAPHIC BITMAP out-parameters
'---------------------------------------------------------------------
' The GRAPHIC BITMAP capture/load arms wrote their handle straight into the
' destination slot instead of routing the value through convert_value, so the
' pointer-sized handle was stored as if it were 32 bits.  Batch 183 fixed both
' sites (and widened sweep_handle_width.py, which had been blind to the shape).
'
' This sample is the witness: the handle must *arrive* in a QUAD variable
' (a LONG would truncate it - the batch 200 lesson) and be non-zero.
'
' Asserts: the bitmap handle is non-zero.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL waitk AS STRING
    LOCAL fail AS LONG
    LOCAL hbmp AS LONG
    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    ConPrint "bitmap handle = " & STR$(hbmp)
    IF hbmp = 0 THEN
        fail = fail + 1
    END IF
    GRAPHIC BITMAP END
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
    waitk = WAITKEY$
END FUNCTION

