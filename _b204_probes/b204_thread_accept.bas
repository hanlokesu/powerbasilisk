GLOBAL g_accepted AS LONG

FUNCTION Acceptor () AS LONG
    LOCAL s AS STRING
    TCP ACCEPT #1 AS #2
    g_accepted = 1
    PRINT "thread accepted"
    TCP LINE INPUT #2, s
    PRINT "server got: "; s
    TCP CLOSE #2
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    TCP OPEN SERVER PORT 46223 AS #1
    PRINT "listening"
    THREAD CREATE Acceptor
    SLEEP 3000
    PRINT "main done, accepted flag = "; g_accepted
    TCP CLOSE #1
    FUNCTION = 0
END FUNCTION
