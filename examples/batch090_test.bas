' Batch 90: CBOOL — convert expression to boolean
' PB TRUE = -1 (all bits 1), FALSE = 0
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL passed AS LONG
    passed = 1

    ' Test 1: CBOOL(0) = 0 (FALSE)
    n = CBOOL(0)
    IF n <> 0 THEN PRINT "Test 1 FAIL: CBOOL(0) = "; n; " expected 0" : passed = 0

    ' Test 2: CBOOL(1) = -1 (TRUE)
    n = CBOOL(1)
    IF n <> -1 THEN PRINT "Test 2 FAIL: CBOOL(1) = "; n; " expected -1" : passed = 0

    ' Test 3: CBOOL(-5) = -1 (TRUE, non-zero)
    n = CBOOL(-5)
    IF n <> -1 THEN PRINT "Test 3 FAIL: CBOOL(-5) = "; n; " expected -1" : passed = 0

    ' Test 4: CBOOL(100) = -1 (TRUE)
    n = CBOOL(100)
    IF n <> -1 THEN PRINT "Test 4 FAIL: CBOOL(100) = "; n; " expected -1" : passed = 0

    ' Test 5: CBOOL with expression (2+3) = -1
    n = CBOOL(2 + 3)
    IF n <> -1 THEN PRINT "Test 5 FAIL: CBOOL(2+3) = "; n; " expected -1" : passed = 0

    ' Test 6: CBOOL with expression (5-5) = 0
    n = CBOOL(5 - 5)
    IF n <> 0 THEN PRINT "Test 6 FAIL: CBOOL(5-5) = "; n; " expected 0" : passed = 0

    ' Test 7: CBOOL can be used in IF
    IF CBOOL(42) THEN
        ' TRUE branch
    ELSE
        PRINT "Test 7 FAIL: CBOOL(42) should be TRUE"
        passed = 0
    END IF

    ' Test 8: CBOOL(0) in IF should be FALSE
    IF CBOOL(0) THEN
        PRINT "Test 8 FAIL: CBOOL(0) should be FALSE"
        passed = 0
    END IF

    IF passed THEN
        PRINT "=== 8/8 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
