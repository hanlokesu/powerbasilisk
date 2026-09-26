'=====================================================================
' PowerBasilisk Enhanced - batch 205 self-check - TCP loopback in ONE program
'---------------------------------------------------------------------
' WHY BATCH 204 COULD NOT SHIP THIS
'   Batch 204 sent bare bytes - `TCP SEND #3, "ping"` and `TCP SEND #2, "pong"` -
'   and then called `TCP LINE INPUT` on both ends.  LINE INPUT reads until a
'   line terminator, so each side waited for a newline the other never sent:
'   a mutual deadlock.  That was my test's fault, not the runtime's - the
'   runtime's `pb_tcp_open` / `pb_tcp_accept` are plain blocking calls with no
'   lock, and batch 204's external-peer probes passed because the Python peer
'   sent its line with a trailing newline.
'
' WHAT THIS FILE DOES DIFFERENTLY
'   It uses TCP PRINT, which appends CR/LF (`pb_tcp_print(f, data, nl)`), so the
'   conversation is line-oriented on both sides - the way a line-oriented
'   protocol must be written.
'
' THE CONVERSATION
'   main   : TCP OPEN SERVER PORT 46219 AS #1
'   thread : TCP ACCEPT #1 AS #2  ->  TCP LINE INPUT #2, s  ->  TCP PRINT #2, "pong"
'   main   : TCP OPEN PORT 46219 AT "127.0.0.1" AS #3
'            TCP PRINT #3, "ping"  ->  TCP LINE INPUT #3, s
'   "pong" can only reach the client if accept, send and line input all worked.
'
' Expected output:
'   client got: pong
'   server read: ping
'   accepted flag: 1
'   === FAILURES: 0
'=====================================================================
GLOBAL g_accepted AS LONG
GLOBAL g_server_line AS STRING

FUNCTION Acceptor () AS LONG
    LOCAL s AS STRING
    TCP ACCEPT #1 AS #2
    g_accepted = 1
    TCP LINE INPUT #2, s
    g_server_line = s
    TCP PRINT #2, "pong"
    TCP CLOSE #2
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    LOCAL s AS STRING
    LOCAL fails AS LONG
    fails = 0
    TCP OPEN SERVER PORT 46219 AS #1
    THREAD CREATE Acceptor
    SLEEP 400
    TCP OPEN PORT 46219 AT "127.0.0.1" AS #3
    TCP PRINT #3, "ping"
    TCP LINE INPUT #3, s
    PRINT "client got: "; s
    IF s <> "pong" THEN fails = fails + 1
    SLEEP 500
    PRINT "server read: "; g_server_line
    IF g_server_line <> "ping" THEN fails = fails + 1
    PRINT "accepted flag: "; g_accepted
    IF g_accepted <> 1 THEN fails = fails + 1
    TCP CLOSE #3
    TCP CLOSE #1
    PRINT "=== FAILURES: "; fails
    FUNCTION = 0
END FUNCTION
