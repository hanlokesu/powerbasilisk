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

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL f AS LONG
    LOCAL content AS STRING
    LOCAL w AS LONG
    LOCAL h AS LONG
    LOCAL f10 AS STRING * 10
    LOCAL ok AS LONG
    ok = 0

    ' MKBYT$ - 1-byte binary string
    s = MKBYT$(65)
    IF LEN(s) <> 1 THEN ok = ok + 1
    IF ASC(s) <> 65 THEN ok = ok + 10

    ' CSET - center in fixed-length string
    CSET f10 = "AB"
    IF LEFT$(f10, 4) <> "    " THEN ok = ok + 100
    IF RIGHT$(f10, 4) <> "    " THEN ok = ok + 1000

    ' PUT$ / GET$ - binary string I/O
    f = FREEFILE
    OPEN "b15_tmp.dat" FOR BINARY AS #f
    PUT$ #f, "Hello12345"
    SEEK #f, 1
    GET$ #f, 5, content
    IF content <> "Hello" THEN ok = ok + 10000
    CLOSE #f
    KILL "b15_tmp.dat"

    ' DESKTOP GET SIZE
    DESKTOP GET SIZE TO w, h
    IF w <= 0 OR h <= 0 THEN ok = ok + 100000

    IF ok = 0 THEN
        ConPrint "BATCH15 ALL PASS"
        FUNCTION = 0
    ELSE
        ConPrint "BATCH15 FAIL code=" & STR$(ok)
        FUNCTION = 1
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


