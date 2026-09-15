' Batch 85: FLOOR function - round down to nearest integer
FUNCTION PBMAIN() AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 85: FLOOR function ==="

    ' Test 1: positive fractional
    r = FLOOR(3.7)
    PRINT "Test 1: FLOOR(3.7) ="; r
    IF r = 3 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 3)"
    END IF

    ' Test 2: negative fractional (floor goes more negative)
    r = FLOOR(-3.7)
    PRINT "Test 2: FLOOR(-3.7) ="; r
    IF r = -4 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected -4)"
    END IF

    ' Test 3: exact integer
    r = FLOOR(3.0)
    PRINT "Test 3: FLOOR(3.0) ="; r
    IF r = 3 THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 3)"
    END IF

    ' Test 4: small positive
    r = FLOOR(0.5)
    PRINT "Test 4: FLOOR(0.5) ="; r
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
