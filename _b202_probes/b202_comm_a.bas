FUNCTION PBMAIN () AS LONG
    COMM OPEN "COM1", 1
    PRINT "comm open returned"
    COMM CLOSE 1
    PRINT "comm close returned"
    FUNCTION = 0
END FUNCTION
