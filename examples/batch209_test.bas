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

'=====================================================================
' batch209_test.bas - batch 209: the five parked drops report, exactly once each
'---------------------------------------------------------------------
' ACCEL ATTACH / EVENT SOURCE / EVENTS / RAISEEVENT / INSTANCE were parsed,
' compiled clean and produced no code - and the coverage table called them
' Implemented.  Batch 209 made the drop visible: the shared arm now pushes to
' compiler.warnings, which prints one summary line and one line per statement in
' batch209_test.unimplemented.log.
'
' The compile-time assertion (external to this file, because a warning cannot be
' observed from inside the program):
'
'   * exactly FOUR report lines here (this sample uses the four object-model
'     statements; batch210_test.bas adds ACCEL ATTACH for the fifth), and
'   * no duplicates - batch 195 pushed the same warning from two places and
'     batch 196 kept only one, so "how many lines" is a real regression signal.
'
' The run-time assertion is the positive control: the ImageList statement next
' to them must keep working while the reported ones stay parked.
'
' Asserts: the ImageList handle arrives and a fresh list reports count 0.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hil AS LONG
    LOCAL cnt AS LONG
    ' INSTANCE myObj AS MyClass  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' EVENTS Click, Changed  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' EVENT SOURCE 1  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' RAISEEVENT Click  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    IMAGELIST GET COUNT hil TO cnt
    ConPrint "imagelist handle = " & STR$(hil) & "  count = " & STR$(cnt)
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
WAITKEY$
END FUNCTION
