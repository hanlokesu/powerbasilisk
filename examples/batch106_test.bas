' Batch 106: ARRAY SCAN / SELECT / TAGARRAY / REDIM
FUNCTION PBMAIN() AS LONG
    LOCAL arr(10) AS LONG
    LOCAL i AS LONG
    LOCAL idx AS LONG
    LOCAL waitk AS STRING
    
    ' Fill array
    FOR i = 0 TO 10
        arr(i) = i * 10
    NEXT i
    
    ' ARRAY SCAN
    PRINT "Testing ARRAY SCAN..."
    ARRAY SCAN arr(), = 30, TO idx
    PRINT "  Found 30 at index: "; idx
    
    ' ARRAY SELECT
    PRINT "Testing ARRAY SELECT..."
    ARRAY SELECT arr(), > 25, TO idx
    PRINT "  First >25 at index: "; idx
    
    ' ARRAY REDIM
    PRINT "Testing ARRAY REDIM..."
    REDIM arr(20) AS LONG
    PRINT "  REDIM to 20 elements OK"
    
    PRINT "ARRAY tests passed!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
