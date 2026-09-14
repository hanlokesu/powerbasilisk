' PowerBasilisk Enhanced - batch 40: ChrToOem$ / OemToChr$ / ChrToUtf8$ / Utf8ToChr$
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL r AS STRING
    failures = 0

    ' round-trips must return the original ANSI text
    r = OemToChr$(ChrToOem$("Hello"))
    Check(r = "Hello", "oem roundtrip")
    r = Utf8ToChr$(ChrToUtf8$("PowerBASIC"))
    Check(r = "PowerBASIC", "utf8 roundtrip")
    r = ChrToUtf8$("AB")
    Check(r = "AB", "utf8 ascii")

    IF failures = 0 THEN
        PRINT "batch40: ALL PASS"
    ELSE
        PRINT "batch40: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
