' Batch 97: THREADID (missing function from CHM audit)
FUNCTION PBMAIN() AS LONG
    LOCAL tid AS LONG
    LOCAL pass AS LONG
    LOCAL waitk AS STRING
    pass = 0

    PRINT "=== Batch 97: THREADID ==="

    ' Test 1: THREADID returns non-zero
    tid = THREADID
    IF tid <> 0 THEN
        PRINT "Test 1 THREADID="; tid; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 1 THREADID="; tid; " FAIL (expected non-zero)"
    END IF

    ' Test 2: THREADID with parentheses also works
    tid = THREADID()
    IF tid <> 0 THEN
        PRINT "Test 2 THREADID()="; tid; " OK"
        pass = pass + 1
    ELSE
        PRINT "Test 2 THREADID()="; tid; " FAIL (expected non-zero)"
    END IF

    PRINT "=== "; pass; "/2 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
