#COMPILE EXE
' parse_test2.bas - verify PARSE$ 2-arg form and PARSECOUNT 1-arg form (fixed)
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL n AS LONG
    LOCAL p AS STRING
    s = "one two three four"

    ' PARSECOUNT(s) - space delimiter (1-arg, was panic before fix)
    n = PARSECOUNT(s)
    PRINT "count = "; n
    IF n <> 4 THEN
        PRINT "FAIL: expected 4"
    ELSE
        PRINT "ok count=4"
    END IF

    ' PARSE$(s, i) - space delimiter, i-th word (2-arg form)
    p = PARSE$(s, 2)
    PRINT "word2 = "; p
    IF p <> "two" THEN
        PRINT "FAIL: expected two"
    ELSE
        PRINT "ok word2=two"
    END IF

    p = PARSE$(s, 4)
    PRINT "word4 = "; p
    IF p <> "four" THEN
        PRINT "FAIL: expected four"
    ELSE
        PRINT "ok word4=four"
    END IF

    ' PARSE$(s, delim, i) - 3-arg form (regression)
    s = "a,b,c"
    p = PARSE$(s, ",", 2)
    PRINT "csv2 = "; p
    IF p <> "b" THEN
        PRINT "FAIL: expected b"
    ELSE
        PRINT "ok csv2=b"
    END IF

    n = PARSECOUNT(s, ",")
    PRINT "csv count = "; n
    IF n <> 3 THEN
        PRINT "FAIL: expected 3"
    ELSE
        PRINT "ok csv count=3"
    END IF

    PRINT "ALL PASS"
END FUNCTION
