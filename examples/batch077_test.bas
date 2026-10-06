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

' PowerBasilisk Enhanced - Batch 77 Test: TCP/UDP NOTIFY + PROGRESSBAR + HEADER + ARRAY SELECT/TAGARRAY
FUNCTION PBMAIN() AS LONG
    LOCAL arr(10) AS LONG
    LOCAL tag(10) AS LONG
    LOCAL waitk AS STRING

    ConPrint "=== Batch 77: misc statements ==="

    TCP NOTIFY 1, 3
    ConPrint "TCP NOTIFY: done"

    UDP NOTIFY 2, 3
    ConPrint "UDP NOTIFY: done"

    ' Official PROGRESSBAR syntax is PROGRESSBAR <GET|SET> <POS|RANGE> hDlg, id&, ...
    ' There is no dialog in this console sample, so the calls resolve to no
    ' control and return 0 - the point here is that they compile and link.
    PROGRESSBAR SET RANGE 0, 101, 0, 100
    PROGRESSBAR SET POS 0, 101, 50
    PROGRESSBAR SET STEP 0, 101, 5
    PROGRESSBAR STEP 0, 101
    PROGRESSBAR STEP 0, 101, 2
    ConPrint "PROGRESSBAR: done"

    ' Official HEADER syntax is HEADER SEND hWin, ID&, Msg&, wParam&, lParam& [TO res&].
    HEADER SEND 0, 102, &H1200, 0, 0
    ConPrint "HEADER: done"

    ARRAY SELECT arr(0), 1, 5
    ConPrint "ARRAY SELECT: done"

    ARRAY TAGARRAY arr(0), tag(0)
    ConPrint "ARRAY TAGARRAY: done"

    ARRAY TAGARRAY ERASE arr(0)
    ConPrint "ARRAY TAGARRAY ERASE: done"

    ConPrint "=== Result: ALL PASS (7 statements)"
    ConPrint "Press any key to exit..."
END FUNCTION
