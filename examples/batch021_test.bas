' batch21_test.bas - COMM serial port + THREAD statements (batch 21)
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
        THREAD CLOSE id
        PRINT "THREAD OK"
    END IF

    WAITKEY$
END FUNCTION

SUB worker()
    DO
    LOOP
END SUB
