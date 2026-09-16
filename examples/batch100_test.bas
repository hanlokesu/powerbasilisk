' Batch 100: BITSE test
FUNCTION PBMAIN() AS LONG
    LOCAL x AS LONG
    LOCAL r AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 100: BITSE ==="

    ' Test 1: BITSE on bit that is 0 — should return 0 and set bit to 1
    x = 0  ' binary: 0000
    r = BITSE(x, 1)  ' test bit 1 (value 2), set it
    PRINT "Test 1: x=0, BITSE(x,1) returns "; r; ", x becomes "; x
    IF r = 0 AND x = 2 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 2: BITSE on bit that is 1 — should return 1 and keep bit 1
    x = 2  ' binary: 0010 (bit 1 set)
    r = BITSE(x, 1)  ' test bit 1, already set
    PRINT "Test 2: x=2, BITSE(x,1) returns "; r; ", x becomes "; x
    IF r = 1 AND x = 2 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 3: BITSE on bit 0
    x = 5  ' binary: 0101 (bits 0 and 2 set)
    r = BITSE(x, 1)  ' bit 1 is 0, should return 0, set to 1
    PRINT "Test 3: x=5, BITSE(x,1) returns "; r; ", x becomes "; x
    IF r = 0 AND x = 7 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    ' Test 4: BITSE on bit 3 (already set)
    x = 8  ' binary: 1000
    r = BITSE(x, 3)  ' bit 3 is 1, should return 1
    PRINT "Test 4: x=8, BITSE(x,3) returns "; r; ", x becomes "; x
    IF r = 1 AND x = 8 THEN PRINT "  PASS" ELSE PRINT "  FAIL"

    PRINT ""
    PRINT "=== Batch 100 tests complete ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
