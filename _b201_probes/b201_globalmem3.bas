FUNCTION PBMAIN () AS LONG
    LOCAL h AS LONG
    LOCAL p AS LONG
    LOCAL sz AS LONG
    GLOBALMEM ALLOC 64 TO h
    PRINT "handle = "; h
    GLOBALMEM SIZE h TO sz
    PRINT "size = "; sz
    GLOBALMEM LOCK h TO p
    IF p <> 0 THEN PRINT "locked = yes" ELSE PRINT "locked = no"
    GLOBALMEM UNLOCK h TO sz
    GLOBALMEM FREE h TO sz
    PRINT "freed = "; sz
    FUNCTION = 0
END FUNCTION
