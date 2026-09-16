' Batch 89: ERROR$ — error message function
FUNCTION PBMAIN() AS LONG
    LOCAL pass AS LONG
    LOCAL waitk AS STRING
    pass = 0

    PRINT "=== Batch 89: ERROR$ ==="

    ' Test 1: ERROR$(0) = "No error"
    IF ERROR$(0) = "No error" THEN
        PRINT "Test 1 PASS: ERROR$(0) = [No error]"
        pass = pass + 1
    ELSE
        PRINT "Test 1 FAIL: ERROR$(0) = ["; ERROR$(0); "]"
    END IF

    ' Test 2: ERROR$(53) = "File not found"
    IF ERROR$(53) = "File not found" THEN
        PRINT "Test 2 PASS: ERROR$(53) = [File not found]"
        pass = pass + 1
    ELSE
        PRINT "Test 2 FAIL: ERROR$(53) = ["; ERROR$(53); "]"
    END IF

    ' Test 3: ERROR$(11) = "Division by zero"
    IF ERROR$(11) = "Division by zero" THEN
        PRINT "Test 3 PASS: ERROR$(11) = [Division by zero]"
        pass = pass + 1
    ELSE
        PRINT "Test 3 FAIL: ERROR$(11) = ["; ERROR$(11); "]"
    END IF

    ' Test 4: ERROR$(76) = "Path not found"
    IF ERROR$(76) = "Path not found" THEN
        PRINT "Test 4 PASS: ERROR$(76) = [Path not found]"
        pass = pass + 1
    ELSE
        PRINT "Test 4 FAIL: ERROR$(76) = ["; ERROR$(76); "]"
    END IF

    ' Test 5: ERROR$(999) = "Unknown error 999" (unknown code)
    IF ERROR$(999) = "Unknown error 999" THEN
        PRINT "Test 5 PASS: ERROR$(999) = [Unknown error 999]"
        pass = pass + 1
    ELSE
        PRINT "Test 5 FAIL: ERROR$(999) = ["; ERROR$(999); "]"
    END IF

    ' Test 6: ERROR$ (no args) with no error set = "No error"
    IF ERROR$ = "No error" THEN
        PRINT "Test 6 PASS: ERROR$ (no error) = [No error]"
        pass = pass + 1
    ELSE
        PRINT "Test 6 FAIL: ERROR$ (no error) = ["; ERROR$; "]"
    END IF

    ' Test 7: ERROR$(2) = "Syntax error"
    IF ERROR$(2) = "Syntax error" THEN
        PRINT "Test 7 PASS: ERROR$(2) = [Syntax error]"
        pass = pass + 1
    ELSE
        PRINT "Test 7 FAIL: ERROR$(2) = ["; ERROR$(2); "]"
    END IF

    ' Test 8: ERROR$(70) = "Permission denied"
    IF ERROR$(70) = "Permission denied" THEN
        PRINT "Test 8 PASS: ERROR$(70) = [Permission denied]"
        pass = pass + 1
    ELSE
        PRINT "Test 8 FAIL: ERROR$(70) = ["; ERROR$(70); "]"
    END IF

    PRINT "=== "; pass; "/8 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
