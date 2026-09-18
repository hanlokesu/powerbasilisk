' Batch 116: DISPLAY OPENFILE + BROWSE
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING

    PRINT "=== Batch 116: DISPLAY OPENFILE + BROWSE ==="
    PRINT ""

    ' Test 1: DISPLAY OPENFILE (real dialog)
    PRINT "Test 1: DISPLAY OPENFILE"
    PRINT "  (A file dialog will appear - pick any file)"
    DISPLAY OPENFILE "Pick a file" TO s
    PRINT "  You picked: [" + s + "]"
    PRINT ""

    ' Test 2: DISPLAY BROWSE (real dialog)
    PRINT "Test 2: DISPLAY BROWSE"
    PRINT "  (A folder dialog will appear - pick any folder)"
    DISPLAY BROWSE "Pick a folder" TO s
    PRINT "  You picked: [" + s + "]"
    PRINT ""

    PRINT "=== ALL TESTS DONE ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
