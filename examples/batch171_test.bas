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
' batch171_test.bas - batch 171: CHR$() on a BYTE-typed argument
'---------------------------------------------------------------------
' Batch 171 did two things: it wrote the three samples that batches 167/168/169
' had been missing, and it fixed a real defect - CHR$() called with a BYTE-typed
' argument emitted illegal IR (a to_i32 on an already-32-bit value), which broke
' the build for a legal program.
'
' This sample is the regression witness for the second half: CHR$ takes a BYTE
' and must produce the character that byte names.  The HEADER item-index half of
' the batch is covered by the 167/168/169 samples this batch wrote.
'
' Asserts: CHR$(65) = "A" and CHR$(90) = "Z".
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL b AS BYTE
    LOCAL s AS STRING
    b = 65
    s = CHR$(b)
    ConPrint "CHR$(65) = " & STR$(s)
    IF s <> "A" THEN
        fail = fail + 1
    END IF
    b = 90
    s = CHR$(b)
    ConPrint "CHR$(90) = " & STR$(s)
    IF s <> "Z" THEN
        fail = fail + 1
    END IF
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
ConWaitKey
END FUNCTION

