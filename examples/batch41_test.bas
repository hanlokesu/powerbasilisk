' PowerBasilisk Enhanced - batch 41: BUILD$ / CLIP$ / WRAP$ / UNWRAP$ / SHRINK$
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
    failures = 0

    x = BUILD$("a", "b", "c")
    Check(x = "abc", "build")
    x = CLIP$(LEFT "abcdef", 2)
    Check(x = "cdef", "clip left")
    x = CLIP$(RIGHT "abcdef", 2)
    Check(x = "abcd", "clip right")
    x = CLIP$(MID "abcdef", 3, 2)
    Check(x = "abef", "clip mid")
    x = WRAP$("MyWord", "<", ">")
    Check(x = "<MyWord>", "wrap")
    x = UNWRAP$("<MyWord>", "<", ">")
    Check(x = "MyWord", "unwrap")
    x = SHRINK$("  a   b  c ")
    Check(x = "a b c", "shrink")

    IF failures = 0 THEN
        PRINT "batch41: ALL PASS"
    ELSE
        PRINT "batch41: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
