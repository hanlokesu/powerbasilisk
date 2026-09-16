' Batch 102: EQV + IMP operators test
FUNCTION PBMAIN() AS LONG
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 102: EQV + IMP ==="

    ' Test 1: EQV - both true (-1) should be true (-1)
    a = -1: b = -1
    r = a EQV b
    PRINT "Test 1: (-1) EQV (-1) = "; r; " (expected -1)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 2: EQV - both false (0) should be true (-1)
    a = 0: b = 0
    r = a EQV b
    PRINT "Test 2: 0 EQV 0 = "; r; " (expected -1)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 3: EQV - different should be false (0)
    a = -1: b = 0
    r = a EQV b
    PRINT "Test 3: (-1) EQV 0 = "; r; " (expected 0)"
    IF r = 0 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 4: IMP - true implies true = true (-1)
    a = -1: b = -1
    r = a IMP b
    PRINT "Test 4: (-1) IMP (-1) = "; r; " (expected -1)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 5: IMP - true implies false = false (0)
    a = -1: b = 0
    r = a IMP b
    PRINT "Test 5: (-1) IMP 0 = "; r; " (expected 0)"
    IF r = 0 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 6: IMP - false implies anything = true (-1)
    a = 0: b = 0
    r = a IMP b
    PRINT "Test 6: 0 IMP 0 = "; r; " (expected -1)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 7: IMP - false implies true = true (-1)
    a = 0: b = -1
    r = a IMP b
    PRINT "Test 7: 0 IMP (-1) = "; r; " (expected -1)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 8: EQV with numbers (bitwise)
    a = 5: b = 5
    r = a EQV b
    PRINT "Test 8: 5 EQV 5 = "; r; " (expected -1, all bits same)"
    IF r = -1 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    PRINT ""
    PRINT "=== Batch 102 tests complete ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
