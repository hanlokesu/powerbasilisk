#COMPILE EXE
' batch19_test.bas - TCP + UDP sockets (11 statements, batch 19)
' Requires two consoles: run tcp_echo_server.exe first, then this test.
' Loopback demo: TCP echo + UDP echo.

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    DIM r AS STRING
    DIM ip AS LONG
    DIM port AS LONG
    ' --- TCP client ---
    TCP OPEN PORT 23456 AT "127.0.0.1" AS #1 TIMEOUT 8000
    PRINT "TCP: connected"
    TCP PRINT #1, "hello-from-client"
    TCP RECV #1, 9, r
    PRINT "TCP: got [" + r + "]"
    TCP CLOSE #1
    ' --- UDP client (no PORT = random local port, PB semantics) ---
    UDP OPEN AS #1 TIMEOUT 5000
    UDP SEND #1, AT "127.0.0.1", 23460, "hello-udp"
    UDP RECV #1, FROM ip, port, r
    PRINT "UDP: got [" + r + "]"
    UDP CLOSE #1
    FUNCTION = 0
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
