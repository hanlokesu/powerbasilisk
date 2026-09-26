GLOBAL g_ran AS LONG
FUNCTION ThreadBody () AS LONG
    g_ran = 1
    PRINT "inside thread"
    FUNCTION = 0
END FUNCTION
FUNCTION PBMAIN () AS LONG
    THREAD CREATE ThreadBody
    SLEEP 300
    PRINT "g_ran = "; g_ran
    FUNCTION = 0
END FUNCTION
