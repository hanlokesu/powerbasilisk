' PowerBasilisk Enhanced - batch 43: BITS$ / PATHNAME$ / PRINTERCOUNT
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
    failures = 0

    x = BITS$(STRING, "abc")
    Check(x = "abc", "bits str")
    x = PATHNAME$(PATH, "C:\data\files\demo.txt")
    Check(x = "C:\data\files\", "pathname path")
    x = PATHNAME$(NAME, "C:\data\files\demo.txt")
    Check(x = "demo", "pathname name")
    x = PATHNAME$(EXTN, "C:\data\files\demo.txt")
    Check(x = ".txt", "pathname extn")
    x = PATHNAME$(NAMEX, "C:\data\files\demo.txt")
    Check(x = "demo.txt", "pathname namex")
    x = PATHNAME$(FULL, "C:\data\files\demo.txt")
    Check(x = "C:\data\files\demo.txt", "pathname full")
    n = PRINTERCOUNT
    Check(n >= 0, "printercount")

    IF failures = 0 THEN
        PRINT "batch43: ALL PASS"
    ELSE
        PRINT "batch43: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
