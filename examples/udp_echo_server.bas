#COMPILE EXE
' udp_echo.bas - UDP echo demo for PowerBasilisk Enhanced (batch 19)
' Run udp_echo_server.exe and udp_echo_client.exe in two consoles (server first).

FUNCTION PBMAIN() AS LONG
    DIM buf AS STRING
    DIM ip AS LONG
    DIM port AS LONG
    UDP OPEN PORT 23460 AS #1 TIMEOUT 8000
    PRINT "server: listening on UDP port 23460"
    UDP RECV #1, FROM ip, port, buf
    PRINT "server: got [" + buf + "]"
    UDP SEND #1, AT ip, port, "echo-udp"
    PRINT "server: replied"
    UDP CLOSE #1
    FUNCTION = 0
END FUNCTION
