' Batch 99: CHRBYTES + FUNCNAME$ test
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    LOCAL result AS LONG

    PRINT "=== Batch 99: CHRBYTES + FUNCNAME$ ==="

    ' Test 1: CHRBYTES with dynamic string (should return 1)
    s = "hello"
    result = CHRBYTES(s)
    PRINT "Test 1: CHRBYTES(dynamic string) = "; result; " (expected 1)"
    IF result = 1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 2: CHRBYTES with empty string
    s = ""
    result = CHRBYTES(s)
    PRINT "Test 2: CHRBYTES(empty string) = "; result; " (expected 1)"
    IF result = 1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 3: FUNCNAME$ inside PBMAIN (should return "PBMAIN")
    s = FUNCNAME$
    PRINT "Test 3: FUNCNAME$ in PBMAIN = ["; s; "] (expected PBMAIN)"
    IF s = "PBMAIN" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 4: FUNCNAME$ bare form (no parens)
    s = FUNCNAME
    PRINT "Test 4: FUNCNAME (bare) = ["; s; "] (expected PBMAIN)"
    IF s = "PBMAIN" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 5: Call a sub and check FUNCNAME$ inside it
    CALL TestSub()

    PRINT ""
    PRINT "=== Batch 99 tests complete ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

SUB TestSub()
    LOCAL s AS STRING
    s = FUNCNAME$
    PRINT "Test 5: FUNCNAME$ in TestSub = ["; s; "] (expected TESTSUB)"
    IF s = "TESTSUB" THEN PRINT "  PASS" ELSE PRINT "  FAIL"
END SUB
