' Batch 95: SEC/CSC/COT/SECH/CSCH — reciprocal trig + hyperbolic functions
FUNCTION PBMAIN() AS LONG
    LOCAL passed AS LONG
    LOCAL v AS DOUBLE
    passed = 1

    ' Test 1: SEC(0) = 1/cos(0) = 1
    v = SEC(0)
    IF ABS(v - 1) > 0.0001 THEN PRINT "Test 1 FAIL: SEC(0) = "; v; " expected 1" : passed = 0

    ' Test 2: CSC(pi/2) = 1/sin(pi/2) = 1 (use 1.5708)
    v = CSC(1.5708)
    IF ABS(v - 1) > 0.001 THEN PRINT "Test 2 FAIL: CSC(pi/2) = "; v; " expected ~1" : passed = 0

    ' Test 3: COT(pi/4) = 1/tan(pi/4) = 1 (use 0.7854)
    v = COT(0.7854)
    IF ABS(v - 1) > 0.001 THEN PRINT "Test 3 FAIL: COT(pi/4) = "; v; " expected ~1" : passed = 0

    ' Test 4: SECH(0) = 1/cosh(0) = 1
    v = SECH(0)
    IF ABS(v - 1) > 0.0001 THEN PRINT "Test 4 FAIL: SECH(0) = "; v; " expected 1" : passed = 0

    ' Test 5: SECH(1) = 1/cosh(1) ~ 0.6481
    v = SECH(1)
    IF v < 0.64 OR v > 0.66 THEN PRINT "Test 5 FAIL: SECH(1) = "; v; " expected ~0.6481" : passed = 0

    ' Test 6: CSCH(1) = 1/sinh(1) ~ 0.8509
    v = CSCH(1)
    IF v < 0.84 OR v > 0.86 THEN PRINT "Test 6 FAIL: CSCH(1) = "; v; " expected ~0.8509" : passed = 0

    ' Test 7: SEC(1) = 1/cos(1) ~ 1.8508
    v = SEC(1)
    IF v < 1.84 OR v > 1.86 THEN PRINT "Test 7 FAIL: SEC(1) = "; v; " expected ~1.8508" : passed = 0

    ' Test 8: CSC(1) = 1/sin(1) ~ 1.1884
    v = CSC(1)
    IF v < 1.18 OR v > 1.20 THEN PRINT "Test 8 FAIL: CSC(1) = "; v; " expected ~1.1884" : passed = 0

    ' Test 9: COT(1) = 1/tan(1) ~ 0.6421
    v = COT(1)
    IF v < 0.63 OR v > 0.65 THEN PRINT "Test 9 FAIL: COT(1) = "; v; " expected ~0.6421" : passed = 0

    ' Test 10: verify SEC*COS = 1
    v = SEC(0.5) * COS(0.5)
    IF ABS(v - 1) > 0.0001 THEN PRINT "Test 10 FAIL: SEC(0.5)*COS(0.5) = "; v; " expected 1" : passed = 0

    IF passed THEN
        PRINT "=== 10/10 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
