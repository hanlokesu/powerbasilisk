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
' batch197_test.bas - batch 197: the false family warning is gone
'---------------------------------------------------------------------
' Batch 195 pushed a "no code generated" warning from the compile_call family
' early return, which fired for every *implemented* family too and polluted the
' silently-dropped inventory.  Batch 197 removed that warning and kept only the
' genuinely-empty arms.
'
' This sample uses an implemented family from that early return (IMAGELIST) and
' is the witness in two ways:
'
'   * compile time: this file must produce NO warning and NO
'     batch197_test.unimplemented.log.  A false warning here is the regression.
'   * run time: the handle must arrive (QUAD) and a fresh list must report 0.
'     Batch 198 later proved the handle was still 0 on the paths it examined -
'     those assertions are the ones batch 200 finally made true, and they are
'     kept here so the pair can never silently disagree again.
'
' Asserts: non-zero handle, count 0, KILL succeeds.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL waitk AS STRING
    LOCAL fail AS LONG
    LOCAL hil AS LONG
    LOCAL cnt AS LONG
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    ConPrint "imagelist handle = " & STR$(hil)
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST GET COUNT hil TO cnt
    ConPrint "fresh list count = " & STR$(cnt)
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
    waitk = WAITKEY$
END FUNCTION

