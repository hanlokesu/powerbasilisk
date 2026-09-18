' Batch 107: DECLARE / DIM / REDIM
DECLARE SUB MySub()
DECLARE FUNCTION MyFunc(x AS LONG) AS LONG

SUB MySub()
    PRINT "  MySub called"
END SUB

FUNCTION MyFunc(x AS LONG) AS LONG
    FUNCTION = x * 2
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL i AS LONG
    LOCAL arr(5) AS LONG
    LOCAL waitk AS STRING
    
    PRINT "Testing DIM..."
    DIM arr2(10) AS LONG
    PRINT "  DIM arr2(10) OK"
    
    PRINT "Testing REDIM..."
    REDIM arr2(20) AS LONG
    PRINT "  REDIM arr2(20) OK"
    
    PRINT "Testing DECLARE..."
    CALL MySub
    i = MyFunc(5)
    PRINT "  MyFunc(5) = "; i
    
    PRINT "DIM / REDIM / DECLARE tests passed!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
