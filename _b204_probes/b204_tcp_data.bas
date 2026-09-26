GLOBAL g_accepted AS LONG
GLOBAL g_line AS STRING

FUNCTION Acceptor () AS LONG
    LOCAL s AS STRING
    TCP ACCEPT #1 AS #2
    g_accepted = 1
    TCP LINE INPUT #2, s
    g_line = s
    TCP SEND #2, "pong"
    TCP CLOSE #2
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    LOCAL s AS STRING
    TCP OPEN SERVER PORT 46219 AS #1
    THREAD CREATE Acceptor
    SLEEP 400
    TCP OPEN PORT 46219 AT "127.0.0.1" AS #3
    TCP SEND #3, "ping"
    TCP LINE INPUT #3, s
    PRINT "client got: "; s
    SLEEP 400
    PRINT "accepted flag: "; g_accepted
    PRINT "server read: "; g_line
    TCP CLOSE #3
    TCP CLOSE #1
    FUNCTION = 0
END FUNCTION
