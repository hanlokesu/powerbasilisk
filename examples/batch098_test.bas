' Batch 98: ISWIN + MCASE$ test
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    LOCAL result AS LONG

    PRINT "=== Batch 98: ISWIN + MCASE$ ==="

    ' Test 1: MCASE$ basic
    s = MCASE$("hello world")
    PRINT "Test 1: MCASE$('hello world') = ["; s; "]"
    IF s = "Hello World" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 2: MCASE$ with mixed case and punctuation
    s = MCASE$("Cats aren't AL.WAYS good.")
    PRINT "Test 2: MCASE$('Cats aren''t AL.WAYS good.') = ["; s; "]"
    IF s = "Cats Aren'T Al.Ways Good." THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 3: MCASE$ all uppercase
    s = MCASE$("HELLO WORLD")
    PRINT "Test 3: MCASE$('HELLO WORLD') = ["; s; "]"
    IF s = "Hello World" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 4: MCASE$ empty string
    s = MCASE$("")
    PRINT "Test 4: MCASE$('') = ["; s; "]"
    IF s = "" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 5: ISWIN with null handle (should return 0 = FALSE)
    result = ISWIN(0)
    PRINT "Test 5: ISWIN(0) = "; result; " (expected 0)"
    IF result = 0 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 6: ISWIN with invalid handle (should return 0 = FALSE)
    result = ISWIN(999999)
    PRINT "Test 6: ISWIN(999999) = "; result; " (expected 0)"
    IF result = 0 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    PRINT ""
    PRINT "=== Batch 98 tests complete ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
