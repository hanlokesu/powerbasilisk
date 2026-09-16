' Batch 83: RETAIN$ function - retain matching substrings or ANY characters
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL r AS STRING
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 83: RETAIN$ function ==="

    ' Test 1: retain single substring
    s = "a1b2c3"
    r = RETAIN$(s, "1")
    PRINT "Test 1: retain '1' from ['a1b2c3']"
    PRINT "  Result: ["; r; "]"
    IF r = "1" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected '1')"
    END IF

    ' Test 2: retain multiple matching substrings
    s = "a1b1c1"
    r = RETAIN$(s, "1")
    PRINT "Test 2: retain '1' from ['a1b1c1']"
    PRINT "  Result: ["; r; "]"
    IF r = "111" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected '111')"
    END IF

    ' Test 3: ANY - retain only digits
    s = "hello123world456"
    r = RETAIN$(s, ANY, "0123456789")
    PRINT "Test 3: ANY retain digits from ['hello123world456']"
    PRINT "  Result: ["; r; "]"
    IF r = "123456" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected '123456')"
    END IF

    ' Test 4: empty match string returns empty
    s = "abc"
    r = RETAIN$(s, "")
    PRINT "Test 4: retain '' from ['abc']"
    PRINT "  Result: ["; r; "]"
    IF r = "" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected empty)"
    END IF

    PRINT "=== "; pass; "/4 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
