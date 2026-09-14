' PowerBasilisk Enhanced - batch 36: MKE$ (EXT = 8-byte double in this compiler)
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL e AS EXT
    LOCAL a AS STRING
    LOCAL b AS STRING
    failures = 0

    e = 1.5
    a = MKE$(e)
    b = MKD$(e)
    ' MKE$ and MKD$ produce the same 8 bytes because EXT == DOUBLE here
    Check(a = b, "mke = mkd bytes")
    Check(LEN(a) = 8, "mke length 8")

    e = -123.25
    Check(MKE$(e) = MKD$(e), "mke neg")
    Check(LEN(MKE$(e)) = 8, "mke neg len")

    IF failures = 0 THEN
        PRINT "batch36: ALL PASS"
    ELSE
        PRINT "batch36: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
