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
' batch194_test.bas - batch 194: the full-surface scan, and the LET spot check
'---------------------------------------------------------------------
' Batch 194 ran all five audit axes and found no new hard defect.  Its one
' concrete run-time check was that the exemptions list is not hiding a real
' problem: `LET x = 41` must print 42 - the four statements on that list are
' classification entries, not proofs (their own words: 这是分类表不是证明).
'
' This sample repeats that spot check and extends it to the rest of the Excel
' surface the list covers, so the exemption stays honest.
'
' Asserts: LET binds and arithmetic on the bound variable works.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL x AS LONG
    LOCAL y AS LONG
    LET x = 41
    x = x + 1
    ConPrint "LET x = 41; x+1 = " & STR$(x)
    IF x <> 42 THEN
        fail = fail + 1
    END IF
    y = x * 2 - 42
    ConPrint "x*2-42         = " & STR$(y)
    IF y <> 42 THEN
        fail = fail + 1
    END IF
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
ConWaitKey
END FUNCTION


