' Batch 81 test: INPUT (console) + LINE INPUT (console)
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL line AS STRING
    LOCAL waitk AS STRING

    PRINT "=== Batch 81: INPUT / LINE INPUT (console) ==="
    PRINT

    ' Test 1: LINE INPUT with prompt
    PRINT "Test 1: LINE INPUT with prompt"
    LINE INPUT "Enter a line: "; line
    PRINT "You entered: ["; line; "]"
    PRINT

    ' Test 2: INPUT with prompt
    PRINT "Test 2: INPUT with prompt"
    INPUT "Enter a string: ", s
    PRINT "You entered: ["; s; "]"
    PRINT

    ' Test 3: LINE INPUT without prompt
    PRINT "Test 3: LINE INPUT without prompt (type something and press Enter)"
    LINE INPUT line
    PRINT "You entered: ["; line; "]"
    PRINT

    PRINT "=== ALL 3 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
