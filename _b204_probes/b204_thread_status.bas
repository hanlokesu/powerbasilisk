GLOBAL g_flag AS LONG

FUNCTION Worker () AS LONG
    SLEEP 600
    g_flag = 1
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    LOCAL st AS LONG
    LOCAL h AS QUAD
    THREAD CREATE Worker TO h
    SLEEP 150
    THREAD STATUS h TO st
    PRINT "status while running: "; st
    SLEEP 900
    THREAD STATUS h TO st
    PRINT "status after finish: "; st
    PRINT "flag: "; g_flag
    THREAD CLOSE h
    PRINT "close returned"
    FUNCTION = 0
END FUNCTION
