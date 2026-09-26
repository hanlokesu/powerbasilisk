FUNCTION PBMAIN () AS LONG
    TCP OPEN PORT 46221 AT "127.0.0.1" AS #3
    PRINT "connect returned"
    TCP SEND #3, "ping-from-pb"
    SLEEP 600
    TCP CLOSE #3
    PRINT "closed"
    FUNCTION = 0
END FUNCTION
