' batch21_test.bas - COMM serial port + THREAD statements (batch 21)
' worker uses a GLOBAL stop flag + SLEEP loop so it can exit before the
' process does - an infinite DO:LOOP worker made process exit hang.
GLOBAL g_stop AS LONG

FUNCTION PBMAIN() AS LONG
    LOCAL id AS LONG, st AS LONG, p AS LONG

    PRINT "== COMM (no real COM port: expect graceful failure, no crash) =="
    COMM OPEN "COM1" AS #0, BAUD 9600, PARITY "N", DATA 8, STOP 1
    COMM RESET
    PRINT "COMM OK (no crash)"

    PRINT "== THREAD =="
    THREAD CREATE worker TO id
    IF id < 0 THEN
        PRINT "THREAD CREATE FAILED rc="; id
    ELSE
        PRINT "thread id="; id
        THREAD STATUS id TO st
        PRINT "status="; st
        THREAD SET PRIORITY id, 0
        THREAD GET PRIORITY id TO p
        PRINT "priority="; p
        THREAD SUSPEND id
        THREAD STATUS id TO st
        PRINT "after suspend status="; st
        THREAD RESUME id
        THREAD STATUS id TO st
        PRINT "after resume status="; st
        g_stop = 1
        SLEEP 20
        THREAD CLOSE id
        PRINT "THREAD OK"
    END IF

    WAITKEY$
END FUNCTION

SUB worker()
    ' SLEEP is a call boundary: keeps the g_stop load fresh (see batch028 NOTE)
    DO WHILE g_stop = 0
        SLEEP 1
    LOOP
END SUB
