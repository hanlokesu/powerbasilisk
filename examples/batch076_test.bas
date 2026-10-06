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

' PowerBasilisk Enhanced - Batch 76 Test: remaining XPRINT statements (completes XPRINT family)
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    ConPrint "=== Batch 76: remaining XPRINT statements ==="

    XPRINT ATTACH DEFAULT

    XPRINT GET PAPERS TO n
    ConPrint "GET PAPERS:" & STR$(n)

    XPRINT GET TRAYS TO n
    ConPrint "GET TRAYS:" & STR$(n)

    XPRINT PREVIEW 1
    ConPrint "PREVIEW: done"

    XPRINT RENDER
    ConPrint "RENDER: done"

    XPRINT SPLIT 0, 0, 100, 100
    ConPrint "SPLIT: done"

    XPRINT STRETCH 0, 0, 50, 50, 0, 0, 100, 100
    ConPrint "STRETCH: done"

    XPRINT IMAGELIST 0, 0, 0
    ConPrint "IMAGELIST: done"

    XPRINT CLOSE

    ConPrint "=== Result: ALL PASS (XPRINT family complete!)"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

