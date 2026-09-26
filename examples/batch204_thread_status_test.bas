'=====================================================================
' PowerBasilisk Enhanced - batch 204 self-check - THREAD STATUS / CLOSE
'---------------------------------------------------------------------
' WHAT WAS MEASURED BEFORE THIS FILE WAS WRITTEN
'   Worker sleeps 700 ms, main checks at 150 ms and again at 1350 ms:
'       status while running: 1
'       status after finish:  3
'       flag: 1
'       close returned
'   So 1 means "alive" and 3 means "finished" in this runtime, and the handle
'   THREAD CREATE ... TO h hands back is a zero-based slot index (the first
'   thread is 0, which is a valid handle - never test a handle against 0).
'   THREAD CLOSE on a finished thread returns without complaint.
'
' WHY IT IS WORTH A SELF-CHECK
'   `THREAD STATUS h TO st` is the only way a program can learn that a worker
'   finished; if the status code were ever left at a stale value the loop that
'   waits for a thread would spin forever.  This file pins the two codes.
'
' NOTE ON THE TCP SIDE (batch 204, verified but not asserted here)
'   TCP was proven with an external peer on each side: PB as client sent a line
'   that a Python server received; PB as server (accept in the main thread AND
'   accept inside a THREAD) read a line a Python client sent.  A single program
'   playing both ends deadlocked, so no such example ships - the reason is not
'   yet understood and is recorded as an open item rather than papered over.
'
' Expected output:
'   status while running: 1
'   status after finish: 3
'   flag: 1
'   closes cleanly
'   === FAILURES: 0
'=====================================================================
GLOBAL g_flag AS LONG

FUNCTION Worker () AS LONG
    SLEEP 700
    g_flag = 1
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    LOCAL st AS LONG
    LOCAL h AS QUAD
    LOCAL fails AS LONG
    fails = 0
    THREAD CREATE Worker TO h
    SLEEP 150
    THREAD STATUS h TO st
    PRINT "status while running: "; st
    IF st <> 1 THEN fails = fails + 1
    SLEEP 1200
    THREAD STATUS h TO st
    PRINT "status after finish: "; st
    IF st <> 3 THEN fails = fails + 1
    PRINT "flag: "; g_flag
    IF g_flag <> 1 THEN fails = fails + 1
    THREAD CLOSE h
    PRINT "closes cleanly"
    PRINT "=== FAILURES: "; fails
    FUNCTION = 0
END FUNCTION
