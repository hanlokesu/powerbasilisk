' Batch 103: #-directives (DEBUG/OPTION/RESOURCE)
#DEBUG BOUNDS
#DEBUG DISPLAY
#DEBUG ERROR
#DEBUG NUMERIC
#OPTION EXPLICIT
#RESOURCE "test.res"

FUNCTION PBMAIN() AS LONG
    LOCAL msg AS STRING
    LOCAL waitk AS STRING
    msg = "All 6 #-directives accepted without error!"
    MSGBOX msg, 0, "Batch 103"
    PRINT "Testing #-directives..."
    PRINT "  #DEBUG BOUNDS  - OK"
    PRINT "  #DEBUG DISPLAY - OK"
    PRINT "  #DEBUG ERROR   - OK"
    PRINT "  #DEBUG NUMERIC - OK"
    PRINT "  #OPTION        - OK"
    PRINT "  #RESOURCE      - OK"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
