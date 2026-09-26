FUNCTION PBMAIN () AS LONG
    COMM OPEN "COM404" AS #1
    PRINT "survived a failed COMM OPEN on channel 1"
    COMM SEND 1, "x"
    COMM CLOSE 1
    PRINT "same channel stays quiet the second time (by design)"
    COMM SEND 2, "x"
    PRINT "a different channel reports again"
    COMM RESET
    PRINT "done"
    FUNCTION = 0
END FUNCTION
