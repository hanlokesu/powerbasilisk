'=====================================================================
' PowerBasilisk Enhanced - batch 203 self-check - UDP on loopback
'---------------------------------------------------------------------
' WHY THIS FILE EXISTS
'   Batch 201 and 202 could only say "the statement compiled and returned".
'   For a socket that is worth nothing: a bind that never binds looks exactly
'   like a bind that works when all you check is the return. This file is the
'   end-to-end proof, and it runs without any network card, router or peer
'   program - the socket talks to itself through 127.0.0.1.
'
' HOW IT PROVES THE SOCKET IS REAL
'   1. UDP OPEN PORT 46217 AS #1      - bind a real UDP socket
'   2. UDP SEND #1, AT "127.0.0.1", 46217, "self-ping"
'   3. UDP RECV #1, FROM ip, pnum, buf
'      The payload and the sender port can only appear if a datagram really
'      travelled through the operating system's socket layer.  A stubbed
'      pb_udp_recv would leave buf empty and the first check would fail.
'
' VERIFIED EXTERNALLY TOO
'   The same statements were driven from outside: a Python socket sent one
'   datagram to this port while the program sat inside UDP RECV, and the
'   program printed the foreign payload ("external-ping").  TCP was checked
'   the same way - `TCP OPEN SERVER PORT p AS #1` really listens, because an
'   external TCP client connected to it successfully.
'
' Expected output:
'   received: self-ping
'   from port: 46217
'   === FAILURES: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL ip AS LONG
    LOCAL pnum AS LONG
    LOCAL buf AS STRING
    LOCAL fails AS LONG
    fails = 0
    UDP OPEN PORT 46217 AS #1
    UDP SEND #1, AT "127.0.0.1", 46217, "self-ping"
    UDP RECV #1, FROM ip, pnum, buf
    PRINT "received: "; buf
    IF buf <> "self-ping" THEN fails = fails + 1
    PRINT "from port: "; pnum
    IF pnum <> 46217 THEN fails = fails + 1
    UDP CLOSE #1
    PRINT "=== FAILURES: "; fails
    FUNCTION = 0
END FUNCTION
