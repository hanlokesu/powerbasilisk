' PARSE / PARSECOUNT verification
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL n AS LONG
    s = "apple,banana,cherry"
    n = PARSECOUNT(s, ",")
    IF n = 3 AND PARSE(s, ",", 2) = "banana" THEN
        PRINT "PARSE-PASS"
    ELSE
        PRINT "PARSE-FAIL n="; n; " p2="; PARSE(s, ",", 2)
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
