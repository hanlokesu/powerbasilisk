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

' Batch 104: File I/O - OPEN/CLOSE/INPUT#/LINE INPUT#/WRITE#
FUNCTION PBMAIN() AS LONG
    LOCAL f AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    
    ' Write test
    f = FREEFILE
    OPEN "test_io.txt" FOR OUTPUT AS #f
    WRITE #f, "hello", 42, 3.14
    CLOSE #f
    ConPrint "Wrote test_io.txt"
    
    ' Read back
    OPEN "test_io.txt" FOR INPUT AS #f
    INPUT #f, s
    ConPrint "Read back: " & s
    CLOSE #f
    
    ' LINE INPUT test
    OPEN "test_io.txt" FOR INPUT AS #f
    LINE INPUT #f, s
    ConPrint "LINE INPUT: " & s
    CLOSE #f
    
    KILL "test_io.txt"
    
    ConPrint "All file I/O tests passed!"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


