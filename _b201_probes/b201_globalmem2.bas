FUNCTION PBMAIN () AS LONG
    LOCAL h AS LONG
    LOCAL p AS LONG
    LOCAL sz AS LONG
    GLOBALMEM ALLOC 64 TO h
    PRINT "handle (no-comma TO) = "; h
    GLOBALMEM SIZE h TO sz
    PRINT "size = "; sz
    GLOBALMEM LOCK h TO p
    PRINT "locked = "; IIF$(p <> 0, "yes", "no")
    GLOBALMEM UNLOCK h TO sz
    GLOBALMEM FREE h TO sz
    PRINT "freed = "; sz
    FUNCTION = 0
END FUNCTION
