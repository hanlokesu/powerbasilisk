' QUAD display: PRINT and PRINT # must not truncate 64-bit values
FUNCTION PBMAIN() AS LONG
    LOCAL q AS QUAD
    LOCAL f AS LONG
    LOCAL s AS STRING
    q = 987654321012345
    PRINT "q="; q
    f = FREEFILE
    OPEN "qprint.dat" FOR OUTPUT AS #f
    PRINT #f, q
    CLOSE #f
    OPEN "qprint.dat" FOR INPUT AS #f
    LINE INPUT #f, s
    CLOSE #f
    KILL "qprint.dat"
    PRINT "file="; s
END FUNCTION
