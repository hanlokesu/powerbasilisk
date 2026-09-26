FUNCTION PBMAIN () AS LONG
    LOCAL ip AS LONG
    LOCAL pnum AS LONG
    LOCAL buf AS STRING
    UDP OPEN PORT 8137 AS #1
    UDP SEND #1, AT "127.0.0.1", 8137, "self-ping"
    UDP RECV #1, FROM ip, pnum, buf
    PRINT "A received: "; buf
    PRINT "A from port: "; pnum
    UDP CLOSE #1
    FUNCTION = 0
END FUNCTION
