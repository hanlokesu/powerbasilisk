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
' batch188_test.bas - batch 188: bucket_noop_names.py, the no-op classifier
'---------------------------------------------------------------------
' This batch changed only the skill's tooling (the batch record says 本批不改仓库), so there is no product behaviour of its own
' to pin.  The sample exists for two reasons:
'
'   * the corpus keeps a 1:1 batch <-> examples/batchN_test.bas mapping, so the
'     release gate always has one file it can compile AND run for the batch;
'   * it is the end-to-end smoke test of that mapping: preprocess -> lex ->
'     parse -> codegen -> link -> run, exercising the runtime calls the shipped
'     hello.bas depends on (CURDIR$, ISFILE, PRINT).
'
' Asserts: the working directory string is non-empty.  Nothing here depends on
' the tooling batch's own artefacts, which live in scripts/ and .github/.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL here AS STRING
    here = CURDIR$
    ConPrint "batch 188 sample (tooling-only batch, nothing of its own in the repo)"
    ConPrint "CURDIR$     = " & here
    ConPrint "ISFILE(exe) = " & STR$(ISFILE("batch188_test.exe"))
    IF LEN(here) = 0 THEN
        fail = fail + 1
    END IF
    ConPrint "=== FAILURES:" & STR$(fail) & "==="
    FUNCTION = fail
' Press any key to exit...
ConWaitKey
END FUNCTION


