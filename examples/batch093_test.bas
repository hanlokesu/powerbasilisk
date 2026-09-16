' Batch 93: ASIN/ACOS/SINH/COSH/TANH — inverse trig + hyperbolic functions
FUNCTION PBMAIN() AS LONG
    LOCAL passed AS LONG
    LOCAL v AS DOUBLE
    passed = 1

    ' Test 1: ASIN(0) = 0
    v = ASIN(0)
    IF ABS(v) > 0.0001 THEN PRINT "Test 1 FAIL: ASIN(0) = "; v; " expected 0" : passed = 0

    ' Test 2: ASIN(1) = pi/2 (~1.5708)
    v = ASIN(1)
    IF v < 1.57 OR v > 1.572 THEN PRINT "Test 2 FAIL: ASIN(1) = "; v; " expected ~1.5708" : passed = 0

    ' Test 3: ACOS(1) = 0
    v = ACOS(1)
    IF ABS(v) > 0.0001 THEN PRINT "Test 3 FAIL: ACOS(1) = "; v; " expected 0" : passed = 0

    ' Test 4: ACOS(0) = pi/2 (~1.5708)
    v = ACOS(0)
    IF v < 1.57 OR v > 1.572 THEN PRINT "Test 4 FAIL: ACOS(0) = "; v; " expected ~1.5708" : passed = 0

    ' Test 5: SINH(0) = 0
    v = SINH(0)
    IF ABS(v) > 0.0001 THEN PRINT "Test 5 FAIL: SINH(0) = "; v; " expected 0" : passed = 0

    ' Test 6: SINH(1) ~ 1.1752
    v = SINH(1)
    IF v < 1.17 OR v > 1.18 THEN PRINT "Test 6 FAIL: SINH(1) = "; v; " expected ~1.1752" : passed = 0

    ' Test 7: COSH(0) = 1
    v = COSH(0)
    IF ABS(v - 1) > 0.0001 THEN PRINT "Test 7 FAIL: COSH(0) = "; v; " expected 1" : passed = 0

    ' Test 8: COSH(1) ~ 1.5431
    v = COSH(1)
    IF v < 1.54 OR v > 1.55 THEN PRINT "Test 8 FAIL: COSH(1) = "; v; " expected ~1.5431" : passed = 0

    ' Test 9: TANH(0) = 0
    v = TANH(0)
    IF ABS(v) > 0.0001 THEN PRINT "Test 9 FAIL: TANH(0) = "; v; " expected 0" : passed = 0

    ' Test 10: TANH(1) ~ 0.7616
    v = TANH(1)
    IF v < 0.76 OR v > 0.77 THEN PRINT "Test 10 FAIL: TANH(1) = "; v; " expected ~0.7616" : passed = 0

    IF passed THEN
        PRINT "=== 10/10 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
