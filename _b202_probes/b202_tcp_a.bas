FUNCTION PBMAIN () AS LONG
    TCP OPEN PORT 8124 AS #1
    PRINT "tcp open returned"
    TCP CLOSE #1
    PRINT "tcp close returned"
    FUNCTION = 0
END FUNCTION
