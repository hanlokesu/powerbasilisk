FUNCTION PBMAIN() AS LONG
    LOCAL p AS LONG
    LOCAL o AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 122: LET * object/variant pointer assign ==="
    LET *p = o
    PRINT "1 LET *p = o accepted OK"

    PRINT ""
    PRINT "=== PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
    DEF fnSqr(x) = x * x
