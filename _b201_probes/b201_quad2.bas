FUNCTION PBMAIN () AS LONG
    LOCAL h AS LONG
    LOCAL p AS QUAD
    LOCAL scratch AS LONG
    GLOBALMEM ALLOC 64 TO h
    PRINT "handle = "; h
    GLOBALMEM LOCK h TO p
    PRINT "ptr nonzero = "; (p <> 0)
    GLOBALMEM FREE h TO scratch
    FUNCTION = 0
END FUNCTION
