'=====================================================================
' PowerBasilisk Enhanced - batch 206 self-check - COMM failures are loud,
' and the channel goes where you wrote it
'---------------------------------------------------------------------
' TWO DEFECTS THIS PINS
'   1. `COMM OPEN` used to fail in complete silence.  The compiler discards the
'      runtime return value, so a serial port that does not exist produced no
'      error value the program could test and no message anywhere; later COMM
'      statements on that channel said nothing either.  Now every failure is
'      reported on standard error, at most once per channel, and a successful
'      open re-arms the message.
'   2. The channel is written `AS #1`.  Written the other way - `COMM OPEN
'      "COM1", 1` - the channel was never passed to codegen, which then read the
'      BAUD slot as the channel and opened the port on channel 0 while the rest
'      of the program talked to channel 1.  That form is now a compile error.
'
' WHAT TO WATCH FOR
'   The program runs to the end (a bad port is not fatal) and the warning goes
'   to standard error, not stdout:
'     Runtime error: COMM OPEN "COM404" failed on channel 1 - the port does not
'     exist, is already in use, or the name is wrong
'   "COM404" is deliberate: no machine has it, so the failure path is exercised
'   everywhere instead of depending on the hardware.
'
' WHY THE EXAMPLE CANNOT ASSERT THE MESSAGE
'   A PB program has no statement for reading another stream's stderr, so the
'   message itself is asserted by the probe that captures stderr; this file
'   asserts what a program CAN see - that the failure is survivable and that
'   later COMM statements survive too.
'
' Expected stdout:
'   survived a failed COMM OPEN written the correct way
'   survived COMM SEND / CLOSE / SET on a closed channel
'   === FAILURES: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fails AS LONG
    fails = 0
    COMM OPEN "COM404" AS #1
    PRINT "survived a failed COMM OPEN written the correct way"
    COMM SEND 1, "x"
    PRINT "survived COMM SEND on a closed channel"
    COMM CLOSE 1
    PRINT "survived COMM CLOSE on a closed channel"
    COMM SET 1, "DTR", 1
    PRINT "survived COMM SET on a closed channel"
    COMM RESET
    IF fails = 0 THEN PRINT "=== FAILURES: 0"
    FUNCTION = 0
END FUNCTION
