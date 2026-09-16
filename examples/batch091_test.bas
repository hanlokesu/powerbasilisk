' Batch 91: Type conversion aliases — CFLT, CLNGINT, CUINT, CULNG
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL s AS SINGLE
    LOCAL passed AS LONG
    passed = 1

    ' Test 1: CFLT(3.14) = 3.14 (Single)
    s = CFLT(3.14)
    IF s < 3.13 OR s > 3.15 THEN PRINT "Test 1 FAIL: CFLT(3.14) = "; s; " expected ~3.14" : passed = 0

    ' Test 2: CFLT(42) = 42.0 (integer to Single)
    s = CFLT(42)
    IF s <> 42.0 THEN PRINT "Test 2 FAIL: CFLT(42) = "; s; " expected 42.0" : passed = 0

    ' Test 3: CLNGINT(3.7) = 4 (banker's rounding, same as CLNG)
    n = CLNGINT(3.7)
    IF n <> 4 THEN PRINT "Test 3 FAIL: CLNGINT(3.7) = "; n; " expected 4" : passed = 0

    ' Test 4: CLNGINT(-2.3) = -2
    n = CLNGINT(-2.3)
    IF n <> -2 THEN PRINT "Test 4 FAIL: CLNGINT(-2.3) = "; n; " expected -2" : passed = 0

    ' Test 5: CUINT(100) = 100 (unsigned int alias)
    n = CUINT(100)
    IF n <> 100 THEN PRINT "Test 5 FAIL: CUINT(100) = "; n; " expected 100" : passed = 0

    ' Test 6: CUINT(5.5) = 6 (rounding)
    n = CUINT(5.5)
    IF n <> 6 THEN PRINT "Test 6 FAIL: CUINT(5.5) = "; n; " expected 6" : passed = 0

    ' Test 7: CULNG(99999) = 99999 (unsigned long alias)
    n = CULNG(99999)
    IF n <> 99999 THEN PRINT "Test 7 FAIL: CULNG(99999) = "; n; " expected 99999" : passed = 0

    ' Test 8: CULNG(0.4) = 0 (round down)
    n = CULNG(0.4)
    IF n <> 0 THEN PRINT "Test 8 FAIL: CULNG(0.4) = "; n; " expected 0" : passed = 0

    IF passed THEN
        PRINT "=== 8/8 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
