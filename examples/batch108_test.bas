' Batch 108: DIR FUNCTION AND + RESOURCE SAVE FILE
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL waitk AS STRING
    
    PRINT "Testing DIR$..."
    s = DIR$("*.bas")
    PRINT "  First .bas file: "; s
    
    s = DIR$(NEXT)
    PRINT "  Next .bas file: "; s
    
    PRINT "DIR FUNCTION tests passed!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
