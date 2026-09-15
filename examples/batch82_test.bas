' Batch 82: REMOVE$ function - remove substrings or ANY characters
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL r AS STRING
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 82: REMOVE$ function ==="

    ' Test 1: remove substring
    s = "the cat sat on the mat"
    r = REMOVE$(s, "the ")
    PRINT "Test 1: remove 'the ' from ['the cat sat on the mat']"
    PRINT "  Result: ["; r; "]"
    IF r = "cat sat on mat" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 'cat sat on mat')"
    END IF

    ' Test 2: remove substring not found
    s = "hello world"
    r = REMOVE$(s, "xyz")
    PRINT "Test 2: remove 'xyz' (not found) from ['hello world']"
    PRINT "  Result: ["; r; "]"
    IF r = "hello world" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 'hello world')"
    END IF

    ' Test 3: ANY - remove any character in match
    s = "hello world"
    r = REMOVE$(s, ANY, "lo")
    PRINT "Test 3: ANY remove 'l','o' from ['hello world']"
    PRINT "  Result: ["; r; "]"
    IF r = "he wrd" THEN
        PRINT "  PASS"
        pass = pass + 1
    ELSE
        PRINT "  FAIL (expected 'he wrd')"
    END IF

    ' Test 4: remove all occurrences
    s = "aaaa"
    r = REMOVE$(s, "aa")
    PRINT "Test 4: remove 'aa' from ['aaaa']"
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
