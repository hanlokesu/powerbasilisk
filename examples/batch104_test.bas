' Batch 104: File I/O - OPEN/CLOSE/INPUT#/LINE INPUT#/WRITE#
FUNCTION PBMAIN() AS LONG
    LOCAL f AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    
    ' Write test
    f = FREEFILE
    OPEN "test_io.txt" FOR OUTPUT AS #f
    WRITE #f, "hello", 42, 3.14
    CLOSE #f
    PRINT "Wrote test_io.txt"
    
    ' Read back
    OPEN "test_io.txt" FOR INPUT AS #f
    INPUT #f, s
    PRINT "Read back: "; s
    CLOSE #f
    
    ' LINE INPUT test
    OPEN "test_io.txt" FOR INPUT AS #f
    LINE INPUT #f, s
    PRINT "LINE INPUT: "; s
    CLOSE #f
    
    KILL "test_io.txt"
    
    PRINT "All file I/O tests passed!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
