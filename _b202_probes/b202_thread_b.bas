GLOBAL g_ran AS LONG
FUNCTION ThreadBody () AS LONG
    g_ran = 1
    PRINT "inside thread"
    FUNCTION = 0
END FUNCTION
FUNCTION PBMAIN () AS LONG
    LOCAL h AS QUAD
    THREAD CREATE ThreadBody TO h
    SLEEP 300
    PRINT "g_ran = "; g_ran
    PRINT "thread handle = "; h
    FUNCTION = 0
END FUNCTION
