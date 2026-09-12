' ELSEIF chain verification
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL t, a AS LONG
    a = 2
    IF a = 1 THEN
        t = 10
    ELSEIF a = 2 THEN
        t = 20
    ELSEIF a = 3 THEN
        t = 30
    ELSE
        t = 99
    END IF
    ' second chain: no match -> ELSE
    IF a = 5 THEN
        t = t + 1000
    ELSEIF a = 6 THEN
        t = t + 2000
    ELSE
        t = t + 3000
    END IF
    PRINT "T="; t
    IF t = 3020 THEN
        PRINT "ELSEIF-PASS"
    ELSE
        PRINT "ELSEIF-FAIL T="; t
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
