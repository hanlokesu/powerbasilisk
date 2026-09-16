' PowerBasilisk Enhanced - batch 42: DAYNAME$ / MONTHNAME$ / DATACOUNT / THREADCOUNT
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL x AS STRING
    LOCAL n AS LONG
    DATA "one", "two", "three"
    failures = 0

    x = DAYNAME$(0)
    Check(x = "Sunday", "day 0")
    x = DAYNAME$(6)
    Check(x = "Saturday", "day 6")
    x = MONTHNAME$(1)
    Check(x = "January", "month 1")
    x = MONTHNAME$(12)
    Check(x = "December", "month 12")
    n = DATACOUNT
    Check(n = 3, "datacount")
    n = THREADCOUNT
    Check(n >= 1, "threadcount")

    IF failures = 0 THEN
        PRINT "batch42: ALL PASS"
    ELSE
        PRINT "batch42: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
