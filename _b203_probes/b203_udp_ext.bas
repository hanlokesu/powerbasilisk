FUNCTION PBMAIN () AS LONG
    LOCAL ip AS LONG
    LOCAL pnum AS LONG
    LOCAL buf AS STRING
    UDP OPEN PORT 8138 AS #1
    PRINT "B ready"
    UDP RECV #1, FROM ip, pnum, buf
    PRINT "B received: "; buf
    UDP CLOSE #1
    FUNCTION = 0
END FUNCTION
