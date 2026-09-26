FUNCTION PBMAIN () AS LONG
    LOCAL h AS LONG
    LOCAL p AS LONG
    GLOBALMEM ALLOC 64 TO h
    PRINT "mem handle = "; h
    GLOBALMEM LOCK h TO p
    PRINT "locked ptr = "; p
    GLOBALMEM UNLOCK h
    GLOBALMEM FREE h
    PRINT "globalmem done"
    FUNCTION = 0
END FUNCTION
