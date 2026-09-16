' Batch 86: TRUNC function - truncate toward zero
FUNCTION PBMAIN() AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 86: TRUNC function ==="

    ' Test 1: positive fractional
    r = TRUNC(3.7)
    PRINT "Test 1: TRUNC(3.7) ="; r
    IF r = 3 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 3)"
    END IF

    ' Test 2: negative fractional (trunc toward zero, NOT floor)
    r = TRUNC(-3.7)
    PRINT "Test 2: TRUNC(-3.7) ="; r
    IF r = -3 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected -3, trunc toward zero)"
    END IF

    ' Test 3: exact integer
    r = TRUNC(3.0)
    PRINT "Test 3: TRUNC(3.0) ="; r
    IF r = 3 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 3)"
    END IF

    ' Test 4: small positive
    r = TRUNC(0.5)
    PRINT "Test 4: TRUNC(0.5) ="; r
    IF r = 0 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 0)"
    END IF

    PRINT "=== "; pass; "/4 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
