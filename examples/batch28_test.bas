' PowerBasilisk Enhanced - batch 28: THREADED (thread-local storage)
' THREADED vars are global to every Sub/Function but each thread has its
' own independent copy. We verify: main sets tcount=1, a child thread sets
' its own tcount=2 and copies it to a plain global; main still reads 1.
'
' NOTE: the main thread waits with SLEEP, not a busy loop -- an optimizer
' is allowed to hoist an invariant global load out of a busy loop, so a
' DO WHILE flag=0 spin can keep reading the pre-thread value forever.
#COMPILE EXE
#DIM ALL

GLOBAL worker_ran AS LONG
GLOBAL worker_val AS LONG
GLOBAL worker_msg AS STRING

THREADED tcount AS LONG
THREADED tmsg AS STRING

SUB Worker()
    THREADED tcount AS LONG
    THREADED tmsg AS STRING
    tcount = 2
    tmsg = "worker"
    worker_val = tcount
    worker_msg = tmsg
    worker_ran = 1
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL th AS LONG
    THREADED tcount AS LONG
    THREADED tmsg AS STRING

    tcount = 1
    tmsg = "main"

    THREAD CREATE Worker() TO th

    ' Give the child thread time to run (SLEEP is a call boundary, so the
    ' loads below are fresh; THREAD CLOSE itself does not wait).
    SLEEP 500

    IF worker_ran = 0 THEN
        PRINT "worker did NOT run -> THREAD CREATE issue"
    ELSE
        PRINT "worker ran: worker_val="; worker_val; " worker_msg="; worker_msg
    END IF

    IF tcount = 1 AND tmsg = "main" THEN
        PRINT "main still sees tcount=1 tmsg=main  -> TLS OK"
    ELSE
        PRINT "main sees tcount="; tcount; " tmsg="; tmsg; " -> TLS FAIL"
    END IF

    THREAD CLOSE th
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
