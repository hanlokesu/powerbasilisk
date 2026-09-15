' Batch 88: ISTRUE / ISFALSE / ISEVEN / ISODD — boolean predicate functions
FUNCTION PBMAIN() AS LONG
    LOCAL pass AS LONG
    LOCAL waitk AS STRING
    pass = 0

    PRINT "=== Batch 88: ISTRUE / ISFALSE / ISEVEN / ISODD ==="

    ' Test 1: ISTRUE — non-zero returns -1 (PB TRUE)
    IF ISTRUE(42) = -1 THEN
        PRINT "Test 1 PASS: ISTRUE(42) = -1"
        pass = pass + 1
    ELSE
        PRINT "Test 1 FAIL: ISTRUE(42) ="; ISTRUE(42); ", expected -1"
    END IF

    ' Test 2: ISTRUE — zero returns 0 (PB FALSE)
    IF ISTRUE(0) = 0 THEN
        PRINT "Test 2 PASS: ISTRUE(0) = 0"
        pass = pass + 1
    ELSE
        PRINT "Test 2 FAIL: ISTRUE(0) ="; ISTRUE(0); ", expected 0"
    END IF

    ' Test 3: ISFALSE — zero returns -1
    IF ISFALSE(0) = -1 THEN
        PRINT "Test 3 PASS: ISFALSE(0) = -1"
        pass = pass + 1
    ELSE
        PRINT "Test 3 FAIL: ISFALSE(0) ="; ISFALSE(0); ", expected -1"
    END IF

    ' Test 4: ISFALSE — non-zero returns 0
    IF ISFALSE(99) = 0 THEN
        PRINT "Test 4 PASS: ISFALSE(99) = 0"
        pass = pass + 1
    ELSE
        PRINT "Test 4 FAIL: ISFALSE(99) ="; ISFALSE(99); ", expected 0"
    END IF

    ' Test 5: ISEVEN — even number returns -1
    IF ISEVEN(10) = -1 THEN
        PRINT "Test 5 PASS: ISEVEN(10) = -1"
        pass = pass + 1
    ELSE
        PRINT "Test 5 FAIL: ISEVEN(10) ="; ISEVEN(10); ", expected -1"
    END IF

    ' Test 6: ISEVEN — odd number returns 0
    IF ISEVEN(7) = 0 THEN
        PRINT "Test 6 PASS: ISEVEN(7) = 0"
        pass = pass + 1
    ELSE
        PRINT "Test 6 FAIL: ISEVEN(7) ="; ISEVEN(7); ", expected 0"
    END IF

    ' Test 7: ISODD — odd number returns -1
    IF ISODD(15) = -1 THEN
        PRINT "Test 7 PASS: ISODD(15) = -1"
        pass = pass + 1
    ELSE
        PRINT "Test 7 FAIL: ISODD(15) ="; ISODD(15); ", expected -1"
    END IF

    ' Test 8: ISODD — even number returns 0
    IF ISODD(8) = 0 THEN
        PRINT "Test 8 PASS: ISODD(8) = 0"
        pass = pass + 1
    ELSE
        PRINT "Test 8 FAIL: ISODD(8) ="; ISODD(8); ", expected 0"
    END IF

    ' Test 9: ISTRUE with negative value
    IF ISTRUE(-5) = -1 THEN
        PRINT "Test 9 PASS: ISTRUE(-5) = -1"
        pass = pass + 1
    ELSE
        PRINT "Test 9 FAIL: ISTRUE(-5) ="; ISTRUE(-5); ", expected -1"
    END IF

    ' Test 10: ISEVEN with zero (zero is even)
    IF ISEVEN(0) = -1 THEN
        PRINT "Test 10 PASS: ISEVEN(0) = -1 (zero is even)"
        pass = pass + 1
    ELSE
        PRINT "Test 10 FAIL: ISEVEN(0) ="; ISEVEN(0); ", expected -1"
    END IF

    PRINT "=== "; pass; "/10 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
