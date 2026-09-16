' Batch 101: ACODE$ test
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL r AS STRING
    LOCAL waitk AS STRING

    PRINT "=== Batch 101: ACODE$ ==="

    ' Test 1: ACODE$ with normal string
    s = "Hello World"
    r = ACODE$(s)
    PRINT "Test 1: ACODE$('Hello World') = ["; r; "]"
    IF r = "Hello World" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 2: ACODE$ with empty string
    s = ""
    r = ACODE$(s)
    PRINT "Test 2: ACODE$('') = ["; r; "]"
    IF r = "" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 3: ACODE$ with special characters
    s = "Test 123 !@#"
    r = ACODE$(s)
    PRINT "Test 3: ACODE$('Test 123 !@#') = ["; r; "]"
    IF r = "Test 123 !@#" THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    PRINT ""
    PRINT "=== Batch 101 tests complete ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
