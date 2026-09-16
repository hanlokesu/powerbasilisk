' Batch 92: FRE() — free memory in bytes
FUNCTION PBMAIN() AS LONG
    LOCAL freemem AS QUAD
    LOCAL passed AS LONG
    passed = 1

    ' Test 1: FRE() returns a positive number (free physical memory)
    freemem = FRE
    IF freemem <= 0 THEN PRINT "Test 1 FAIL: FRE() = "; freemem; " expected > 0" : passed = 0

    ' Test 2: FRE() returns a reasonable value (at least 1MB)
    IF freemem < 1048576 THEN PRINT "Test 2 FAIL: FRE() = "; freemem; " expected >= 1MB" : passed = 0

    ' Test 3: FRE() with string argument (PB syntax: FRE("") triggers garbage collection)
    freemem = FRE("")
    IF freemem <= 0 THEN PRINT "Test 3 FAIL: FRE("") = "; freemem; " expected > 0" : passed = 0

    ' Test 4: FRE() with numeric argument (PB syntax: FRE(0))
    freemem = FRE(0)
    IF freemem <= 0 THEN PRINT "Test 4 FAIL: FRE(0) = "; freemem; " expected > 0" : passed = 0

    ' Test 5: Print the actual free memory value
    PRINT "Free physical memory: "; FRE; " bytes ("; FRE / 1048576; " MB)"

    IF passed THEN
        PRINT "=== 5/5 TESTS PASSED ==="
    ELSE
        PRINT "=== SOME TESTS FAILED ==="
    END IF

    LOCAL waitk AS STRING
    waitk = WAITKEY$
END FUNCTION
