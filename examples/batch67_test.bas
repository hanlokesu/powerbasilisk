' PowerBasilisk Enhanced - Batch 67 test
' ARRAY ADD arr1(), arr2() — element-wise addition
FUNCTION PBMAIN() AS LONG
    DIM a(1 TO 4) AS LONG
    DIM b(1 TO 4) AS LONG
    DIM i AS LONG
    DIM ok AS LONG
    DIM waitk AS STRING
    ok = 0

    ' initialize
    FOR i = 1 TO 4
        a(i) = i * 10
        b(i) = i
    NEXT i

    ' ARRAY ADD: a += b
    ARRAY ADD a(), b()

    ' verify: a(i) should be i*10 + i = i*11
    IF a(1) = 11 AND a(2) = 22 AND a(3) = 33 AND a(4) = 44 THEN
        ok = ok + 1
    ELSE
        PRINT "FAIL: LONG array add"; a(1); a(2); a(3); a(4)
    END IF

    ' test with SINGLE (float)
    DIM fa(1 TO 3) AS SINGLE
    DIM fb(1 TO 3) AS SINGLE
    fa(1) = 1.5 : fa(2) = 2.5 : fa(3) = 3.5
    fb(1) = 0.5 : fb(2) = 1.0 : fb(3) = 1.5
    ARRAY ADD fa(), fb()
    IF fa(1) = 2.0 AND fa(2) = 3.5 AND fa(3) = 5.0 THEN
        ok = ok + 1
    ELSE
        PRINT "FAIL: SINGLE array add"; fa(1); fa(2); fa(3)
    END IF

    ' test with BYTE
    DIM ca(1 TO 3) AS BYTE
    DIM cb(1 TO 3) AS BYTE
    ca(1) = 100 : ca(2) = 200 : ca(3) = 50
    cb(1) = 1 : cb(2) = 2 : cb(3) = 3
    ARRAY ADD ca(), cb()
    IF ca(1) = 101 AND ca(2) = 202 AND ca(3) = 53 THEN
        ok = ok + 1
    ELSE
        PRINT "FAIL: BYTE array add"; ca(1); ca(2); ca(3)
    END IF

    ' test with QUAD (64-bit)
    DIM qa(1 TO 2) AS QUAD
    DIM qb(1 TO 2) AS QUAD
    qa(1) = 10000000000 : qa(2) = 20000000000
    qb(1) = 1 : qb(2) = 2
    ARRAY ADD qa(), qb()
    IF qa(1) = 10000000001 AND qa(2) = 20000000002 THEN
        ok = ok + 1
    ELSE
        PRINT "FAIL: QUAD array add"; qa(1); qa(2)
    END IF

    IF ok = 4 THEN
        PRINT "ALL PASS (4/4)"
    ELSE
        PRINT "FAIL: "; ok
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
