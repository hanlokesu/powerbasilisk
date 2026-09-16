' Batch 96: HYPOT/CBRT/EXPM1/LOG1P/ERF (C math library functions)
FUNCTION PBMAIN() AS LONG
    LOCAL x AS DOUBLE
    LOCAL y AS DOUBLE
    LOCAL r AS DOUBLE
    LOCAL pass AS LONG
    LOCAL waitk AS STRING
    pass = 0

    PRINT "=== Batch 96: HYPOT/CBRT/EXPM1/LOG1P/ERF ==="

    ' Test 1: HYPOT(3,4) = 5
    r = HYPOT(3.0, 4.0)
    IF ABS(r - 5.0) < 0.0001 THEN
        PRINT "Test 1 HYPOT(3,4)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 1 HYPOT(3,4)="; r; " FAIL (expected 5)"
    END IF

    ' Test 2: HYPOT(5,12) = 13
    r = HYPOT(5.0, 12.0)
    IF ABS(r - 13.0) < 0.0001 THEN
        PRINT "Test 2 HYPOT(5,12)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 2 HYPOT(5,12)="; r; " FAIL (expected 13)"
    END IF

    ' Test 3: CBRT(8) = 2
    r = CBRT(8.0)
    IF ABS(r - 2.0) < 0.0001 THEN
        PRINT "Test 3 CBRT(8)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 3 CBRT(8)="; r; " FAIL (expected 2)"
    END IF

    ' Test 4: CBRT(27) = 3
    r = CBRT(27.0)
    IF ABS(r - 3.0) < 0.0001 THEN
        PRINT "Test 4 CBRT(27)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 4 CBRT(27)="; r; " FAIL (expected 3)"
    END IF

    ' Test 5: EXPM1(0) = 0
    r = EXPM1(0.0)
    IF ABS(r - 0.0) < 0.0001 THEN
        PRINT "Test 5 EXPM1(0)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 5 EXPM1(0)="; r; " FAIL (expected 0)"
    END IF

    ' Test 6: EXPM1(1) = e-1 ≈ 1.71828
    r = EXPM1(1.0)
    IF ABS(r - 1.71828) < 0.0001 THEN
        PRINT "Test 6 EXPM1(1)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 6 EXPM1(1)="; r; " FAIL (expected 1.71828)"
    END IF

    ' Test 7: LOG1P(0) = 0
    r = LOG1P(0.0)
    IF ABS(r - 0.0) < 0.0001 THEN
        PRINT "Test 7 LOG1P(0)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 7 LOG1P(0)="; r; " FAIL (expected 0)"
    END IF

    ' Test 8: LOG1P(e-1) = 1
    r = LOG1P(1.71828)
    IF ABS(r - 1.0) < 0.0001 THEN
        PRINT "Test 8 LOG1P(e-1)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 8 LOG1P(e-1)="; r; " FAIL (expected 1)"
    END IF

    ' Test 9: ERF(0) = 0
    r = ERF(0.0)
    IF ABS(r - 0.0) < 0.0001 THEN
        PRINT "Test 9 ERF(0)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 9 ERF(0)="; r; " FAIL (expected 0)"
    END IF

    ' Test 10: ERF(1) ≈ 0.84270
    r = ERF(1.0)
    IF ABS(r - 0.84270) < 0.0001 THEN
        PRINT "Test 10 ERF(1)="; r; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 10 ERF(1)="; r; " FAIL (expected 0.84270)"
    END IF

    PRINT "=== ALL "; pass; "/10 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
