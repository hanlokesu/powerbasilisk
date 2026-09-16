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
        PRINT "B11-BIT-FUNC-PASS"
    ELSE
        PRINT "B11-BIT-FUNC-FAIL"
    END IF

    BIT SET f, 1
    IF f = 7 THEN
        PRINT "B11-BIT-SET-PASS"
    ELSE
        PRINT "B11-BIT-SET-FAIL f="; f
    END IF

    BIT RESET f, 0
    IF f = 6 THEN
        PRINT "B11-BIT-RESET-PASS"
    ELSE
        PRINT "B11-BIT-RESET-FAIL f="; f
    END IF

    BIT TOGGLE f, 2
    IF f = 2 THEN
        PRINT "B11-BIT-TOGGLE-PASS"
    ELSE
        PRINT "B11-BIT-TOGGLE-FAIL f="; f
    END IF

    ' --- 2. PROCESS GET / SET PRIORITY ---
    PROCESS GET PRIORITY TO p
    IF p > 0 THEN
        PRINT "B11-PROCESS-GET-PASS p="; p
    ELSE
        PRINT "B11-PROCESS-GET-FAIL p="; p
    END IF
    PROCESS SET PRIORITY 32
    PROCESS GET PRIORITY TO p
    IF p = 32 THEN
        PRINT "B11-PROCESS-SET-PASS p="; p
    ELSE
        PRINT "B11-PROCESS-SET-FAIL p="; p
    END IF

    ' --- 3. LOF / LOC / SEEK ---
    f = FREEFILE
    OPEN "b11_lof.tmp" FOR OUTPUT AS #f
    WRITE #f, "Hello World"
    CLOSE #f

    OPEN "b11_lof.tmp" FOR INPUT AS #f
    len1 = LOF(f)
    IF len1 >= 11 THEN
        PRINT "B11-LOF-PASS len="; len1
    ELSE
        PRINT "B11-LOF-FAIL len="; len1
    END IF
    CLOSE #f

    f = FREEFILE
    OPEN "b11_lof.tmp" FOR BINARY AS #f
    SEEK #f, 4
    pos1 = LOC(f)
    IF pos1 = 4 THEN
        PRINT "B11-SEEK-LOC-PASS pos="; pos1
    ELSE
        PRINT "B11-SEEK-LOC-FAIL pos="; pos1
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
        PRINT "B11-ARRAY-DELETE-PASS"
    ELSE
        PRINT "B11-ARRAY-DELETE-FAIL"
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
        PRINT "B11-ARRAY-INSERT-PASS"
    ELSE
        PRINT "B11-ARRAY-INSERT-FAIL"
    END IF

    ' --- 6. ARRAY SCAN ---
    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i
    ARRAY SCAN a(), = 30, TO idx
    IF idx = 3 THEN
        PRINT "B11-ARRAY-SCAN-PASS idx="; idx
    ELSE
        PRINT "B11-ARRAY-SCAN-FAIL idx="; idx
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
