#COMPILE EXE
' tcp_echo_client.bas - TCP echo client (pair with tcp_echo_server.bas)

FUNCTION PBMAIN() AS LONG
    DIM r AS STRING
    TCP OPEN PORT 23456 AT "127.0.0.1" AS #1 TIMEOUT 5000
    PRINT "client: connected"
    TCP PRINT #1, "hello-from-client"
    TCP RECV #1, 9, r
    PRINT "client: got [" + r + "]"
    TCP CLOSE #1
    FUNCTION = 0
END FUNCTION
