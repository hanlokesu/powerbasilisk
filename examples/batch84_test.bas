' Batch 84: REMAIN$ function - return portion after first match
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL r AS STRING
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 84: REMAIN$ function ==="

    ' Test 1: basic remain after space
    s = "hello world"
    r = REMAIN$(s, " ")
    PRINT "Test 1: REMAIN$('hello world', ' ')"
    PRINT "  Result: ["; r; "]"
    IF r = "world" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 'world')"
    END IF

    ' Test 2: match not found returns empty
    s = "hello"
    r = REMAIN$(s, "xyz")
    PRINT "Test 2: REMAIN$('hello', 'xyz') (not found)"
    PRINT "  Result: ["; r; "]"
    IF r = "" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected empty)"
    END IF

    ' Test 3: with Start position
    s = "a1b2c3"
    r = REMAIN$(3, s, "b")
    PRINT "Test 3: REMAIN$(3, 'a1b2c3', 'b')"
    PRINT "  Result: ["; r; "]"
    IF r = "2c3" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected '2c3')"
    END IF

    ' Test 4: ANY - remain after first digit
    s = "hello123world"
    r = REMAIN$(s, ANY, "0123456789")
    PRINT "Test 4: REMAIN$('hello123world', ANY, digits)"
    PRINT "  Result: ["; r; "]"
    IF r = "23world" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected '23world')"
    END IF

    PRINT "=== "; pass; "/4 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
