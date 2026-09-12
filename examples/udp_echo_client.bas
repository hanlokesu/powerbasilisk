#COMPILE EXE
' udp_echo_client.bas - UDP echo client (pair with udp_echo_server.bas)
' Note: client uses UDP OPEN without PORT (random local port, PB semantics).

FUNCTION PBMAIN() AS LONG
    DIM buf AS STRING
    DIM ip AS LONG
    DIM port AS LONG
    UDP OPEN AS #1 TIMEOUT 5000
    PRINT "client: sending"
    UDP SEND #1, AT "127.0.0.1", 23460, "hello-udp"
    UDP RECV #1, FROM ip, port, buf
    PRINT "client: got [" + buf + "]"
    UDP CLOSE #1
    FUNCTION = 0
END FUNCTION
