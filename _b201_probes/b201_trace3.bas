FUNCTION PBMAIN () AS LONG
    TRACE NEW "trace_probe.txt"
    TRACE ON
    TRACE PRINT "first traced line"
    TRACE PRINT 42
    TRACE PRINT 3.5
    TRACE OFF
    TRACE PRINT "after off (must not appear)"
    TRACE CLOSE
    PRINT "trace probe done"
    FUNCTION = 0
END FUNCTION
