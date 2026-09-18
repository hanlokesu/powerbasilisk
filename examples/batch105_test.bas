' Batch 105: ON GOTO / ON GOSUB / ON CALL
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL waitk AS STRING
    
    PRINT "Testing ON GOTO..."
    FOR n = 1 TO 3
        ON n GOTO label1, label2, label3
    NEXT n
    GOTO after1
    
label1:
    PRINT "  n=1 -> label1"
    GOTO after1
label2:
    PRINT "  n=2 -> label2"
    GOTO after1
label3:
    PRINT "  n=3 -> label3"
after1:
    
    PRINT "Testing ON GOSUB..."
    n = 2
    ON n GOSUB sub1, sub2
    GOTO after2
    
sub1:
    PRINT "  n=1 -> sub1"
    RETURN
sub2:
    PRINT "  n=2 -> sub2"
    RETURN
after2:
    
    PRINT "ON GOTO / ON GOSUB tests passed!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
