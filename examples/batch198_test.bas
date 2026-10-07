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
' batch198_test.bas - batch 198: the 197 correction, and the dead-arm finding
'---------------------------------------------------------------------
' Two things happened in batch 198:
'
'   1. Batch 197 had called the v0.2.047 warning a false alarm.  Batch 198
'      corrected that: the witness showed the IMAGELIST handle really was 0, so
'      the warning had been pointing at something.  (两处都报警时，「哪个是真」
'      优先于「哪个数字好看」。)
'   2. Removing IMAGELIST_ from the family early return did not reach the arms
'      at all - the statements fell through to the catch-all hard error, i.e.
'      those arms sit in an unreachable dispatcher.  The experiment was rolled
'      back; the fix moved to a later batch.
'
' This sample pins the state the rollback left behind: the documented call form
' compiles and the handle/count pair behaves as batch 200 then made it behave.
' The *negative* half of the batch (the unreachable arms) cannot live in a
' compiling sample; it is recorded in the batch note in scripts/README.md.
'
' Asserts: non-zero handle, count 0 on a fresh list.
'=====================================================================
FUNCTION PBMAIN () AS LONG
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
WAITKEY$
END FUNCTION

