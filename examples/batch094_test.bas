' Batch 94: ATN2/ASINH/ACOSH/ATANH/COTH — more inverse trig + hyperbolic
FUNCTION PBMAIN() AS LONG
    LOCAL passed AS LONG
    LOCAL v AS DOUBLE
    passed = 1

    ' Test 1: ATN2(0, 1) = 0
    v = ATN2(0, 1)
    IF ABS(v) > 0.0001 THEN PRINT "Test 1 FAIL: ATN2(0,1) = "; v; " expected 0" : passed = 0

    ' Test 2: ATN2(1, 0) = pi/2 (~1.5708)
    v = ATN2(1, 0)
    IF v < 1.57 OR v > 1.572 THEN PRINT "Test 2 FAIL: ATN2(1,0) = "; v; " expected ~1.5708" : passed = 0

    ' Test 3: ATN2(1, 1) = pi/4 (~0.7854)
    v = ATN2(1, 1)
    IF v < 0.785 OR v > 0.786 THEN PRINT "Test 3 FAIL: ATN2(1,1) = "; v; " expected ~0.7854" : passed = 0

    ' Test 4: ASINH(0) = 0
    v = ASINH(0)
    IF ABS(v) > 0.0001 THEN PRINT "Test 4 FAIL: ASINH(0) = "; v; " expected 0" : passed = 0

    ' Test 5: ASINH(1) ~ 0.8814
    v = ASINH(1)
    IF v < 0.88 OR v > 0.89 THEN PRINT "Test 5 FAIL: ASINH(1) = "; v; " expected ~0.8814" : passed = 0

    ' Test 6: ACOSH(1) = 0
    v = ACOSH(1)
    IF ABS(v) > 0.0001 THEN PRINT "Test 6 FAIL: ACOSH(1) = "; v; " expected 0" : passed = 0

    ' Test 7: ACOSH(2) ~ 1.3170
    v = ACOSH(2)
    IF v < 1.31 OR v > 1.32 THEN PRINT "Test 7 FAIL: ACOSH(2) = "; v; " expected ~1.3170" : passed = 0

    ' Test 8: ATANH(0) = 0
    v = ATANH(0)
    IF ABS(v) > 0.0001 THEN PRINT "Test 8 FAIL: ATANH(0) = "; v; " expected 0" : passed = 0

    ' Test 9: ATANH(0.5) ~ 0.5493
    v = ATANH(0.5)
    IF v < 0.54 OR v > 0.56 THEN PRINT "Test 9 FAIL: ATANH(0.5) = "; v; " expected ~0.5493" : passed = 0

    ' Test 10: COTH(1) = 1/tanh(1) ~ 1.3130
    v = COTH(1)
    IF v < 1.31 OR v > 1.32 THEN PRINT "Test 10 FAIL: COTH(1) = "; v; " expected ~1.3130" : passed = 0

    IF passed THEN
        PRINT "=== 10/10 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
