#COMPILE EXE
' tcp_echo.bas - TCP echo demo for PowerBasilisk Enhanced (batch 19)
' Run tcp_echo_server.exe and tcp_echo_client.exe in two consoles (server first).

FUNCTION PBMAIN() AS LONG
    DIM line AS STRING
    TCP OPEN SERVER PORT 23456 AS #1 TIMEOUT 8000
    PRINT "server: listening on port 23456"
    TCP ACCEPT #1 AS #2
    PRINT "server: client connected"
    TCP LINE INPUT #2, line
    PRINT "server: got [" + line + "]"
    TCP SEND #2, "echo-back"
    PRINT "server: replied"
    TCP CLOSE #2
    TCP CLOSE #1
    FUNCTION = 0
END FUNCTION
