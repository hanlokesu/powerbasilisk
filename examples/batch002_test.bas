' Batch 2: SWAP / SHIFT / ROTATE / ARRAY REVERSE / PUT$
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL n AS LONG
    LOCAL i AS LONG
    LOCAL f AS LONG
    LOCAL s AS STRING
    LOCAL arr() AS LONG

    a = 1
    b = 2
    SWAP a, b
    IF a = 2 AND b = 1 THEN PRINT "SWAP-PASS" ELSE PRINT "SWAP-FAIL "; a; b

    n = 221
    SHIFT LEFT n, 1
    IF n = 442 THEN PRINT "SHIFTLEFT-PASS" ELSE PRINT "SHIFTLEFT-FAIL "; n
    n = 221
    SHIFT RIGHT n, 1
    IF n = 110 THEN PRINT "SHIFTRIGHT-PASS" ELSE PRINT "SHIFTRIGHT-FAIL "; n
    n = -4
    SHIFT SIGNED RIGHT n, 1
    IF n = -2 THEN PRINT "SHIFTSIGNED-PASS" ELSE PRINT "SHIFTSIGNED-FAIL "; n
    n = 1
    ROTATE LEFT n, 1
    IF n = 2 THEN PRINT "ROTATELEFT-PASS" ELSE PRINT "ROTATELEFT-FAIL "; n
    n = 2
    ROTATE RIGHT n, 1
    IF n = 1 THEN PRINT "ROTATERIGHT-PASS" ELSE PRINT "ROTATERIGHT-FAIL "; n

    REDIM arr(1 TO 5)
    FOR i = 1 TO 5
        arr(i) = i
    NEXT i
    ARRAY REVERSE arr()
    IF arr(1) = 5 AND arr(3) = 3 AND arr(5) = 1 THEN
        PRINT "ARRAYREV-PASS"
    ELSE
        PRINT "ARRAYREV-FAIL "; arr(1); arr(3); arr(5)
    END IF

    f = FREEFILE
    OPEN "putstr_test.dat" FOR BINARY AS #f
    PUT$ #f, "ABC"
    PUT$ #f, "123"
    CLOSE #f
    OPEN "putstr_test.dat" FOR INPUT AS #f
    LINE INPUT #f, s
    CLOSE #f
    KILL "putstr_test.dat"
    IF s = "ABC123" THEN PRINT "PUT$-PASS" ELSE PRINT "PUT$-FAIL ["; s; "]"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
