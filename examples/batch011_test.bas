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

' Batch 11: consolidated regression for batches 6-10
' (BIT family / PROCESS PRIORITY / LOF / LOC / SEEK / ARRAY DELETE / INSERT / SCAN)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL p AS LONG
    LOCAL len1 AS QUAD
    LOCAL pos1 AS QUAD
    LOCAL a() AS LONG
    LOCAL i AS LONG
    LOCAL idx AS LONG
    LOCAL ok AS LONG

    ' --- 1. BIT function + BIT SET / RESET / TOGGLE ---
    f = 5
    IF BIT(f, 0) = 1 AND BIT(f, 2) = 1 AND BIT(f, 1) = 0 THEN
        ConPrint "B11-BIT-FUNC-PASS"
    ELSE
        ConPrint "B11-BIT-FUNC-FAIL"
    END IF

    BIT SET f, 1
    IF f = 7 THEN
        ConPrint "B11-BIT-SET-PASS"
    ELSE
        ConPrint "B11-BIT-SET-FAIL f=" & STR$(f)
    END IF

    BIT RESET f, 0
    IF f = 6 THEN
        ConPrint "B11-BIT-RESET-PASS"
    ELSE
        ConPrint "B11-BIT-RESET-FAIL f=" & STR$(f)
    END IF

    BIT TOGGLE f, 2
    IF f = 2 THEN
        ConPrint "B11-BIT-TOGGLE-PASS"
    ELSE
        ConPrint "B11-BIT-TOGGLE-FAIL f=" & STR$(f)
    END IF

    ' --- 2. PROCESS GET / SET PRIORITY ---
    PROCESS GET PRIORITY TO p
    IF p > 0 THEN
        ConPrint "B11-PROCESS-GET-PASS p=" & STR$(p)
    ELSE
        ConPrint "B11-PROCESS-GET-FAIL p=" & STR$(p)
    END IF
    PROCESS SET PRIORITY 32
    PROCESS GET PRIORITY TO p
    IF p = 32 THEN
        ConPrint "B11-PROCESS-SET-PASS p=" & STR$(p)
    ELSE
        ConPrint "B11-PROCESS-SET-FAIL p=" & STR$(p)
    END IF

    ' --- 3. LOF / LOC / SEEK ---
    f = FREEFILE
    OPEN "b11_lof.tmp" FOR OUTPUT AS #f
    WRITE #f, "Hello World"
    CLOSE #f

    OPEN "b11_lof.tmp" FOR INPUT AS #f
    len1 = LOF(f)
    IF len1 >= 11 THEN
        ConPrint "B11-LOF-PASS len=" & STR$(len1)
    ELSE
        ConPrint "B11-LOF-FAIL len=" & STR$(len1)
    END IF
    CLOSE #f

    f = FREEFILE
    OPEN "b11_lof.tmp" FOR BINARY AS #f
    SEEK #f, 4
    pos1 = LOC(f)
    IF pos1 = 4 THEN
        ConPrint "B11-SEEK-LOC-PASS pos=" & STR$(pos1)
    ELSE
        ConPrint "B11-SEEK-LOC-FAIL pos=" & STR$(pos1)
    END IF
    CLOSE #f
    KILL "b11_lof.tmp"

    ' --- 4. ARRAY DELETE ---
    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i
    ARRAY DELETE a(2)
    ok = 0
    IF a(1) = 10 AND a(2) = 30 AND a(3) = 40 AND a(4) = 50 THEN ok = 1
    IF ok = 1 THEN
        ConPrint "B11-ARRAY-DELETE-PASS"
    ELSE
        ConPrint "B11-ARRAY-DELETE-FAIL"
    END IF

    ' --- 5. ARRAY INSERT ---
    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i
    ARRAY INSERT a(2), 25
    ok = 0
    IF a(1) = 10 AND a(2) = 25 AND a(3) = 20 AND a(4) = 30 AND a(5) = 40 THEN ok = 1
    IF ok = 1 THEN
        ConPrint "B11-ARRAY-INSERT-PASS"
    ELSE
        ConPrint "B11-ARRAY-INSERT-FAIL"
    END IF

    ' --- 6. ARRAY SCAN ---
    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i
    ARRAY SCAN a(), = 30, TO idx
    IF idx = 3 THEN
        ConPrint "B11-ARRAY-SCAN-PASS idx=" & STR$(idx)
    ELSE
        ConPrint "B11-ARRAY-SCAN-FAIL idx=" & STR$(idx)
    END IF

    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION


