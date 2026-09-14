' PowerBasilisk Enhanced - batch 34: PROFILE per-procedure call counts + elapsed ms
GLOBAL failures AS LONG

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    failures = 0
    CALL Work()
    CALL Work()
    CALL Work()
    PROFILE "profile.log"
    IF failures = 0 THEN
        PRINT "batch34: ALL PASS"
    ELSE
        PRINT "batch34: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

SUB Work()
    SLEEP 15
END SUB
