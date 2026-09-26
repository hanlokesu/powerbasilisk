FUNCTION PBMAIN () AS LONG
    UDP OPEN PORT 8123 AS #1
    PRINT "udp open returned"
    UDP CLOSE #1
    PRINT "udp close returned"
    FUNCTION = 0
END FUNCTION
