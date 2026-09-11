' Batch 4: DATA / READ / RESTORE
FUNCTION PBMAIN() AS LONG
    LOCAL a AS STRING
    LOCAL n AS LONG
    LOCAL d AS DOUBLE
    LOCAL w AS STRING

    DATA "Hello", 42, 3.14, "World"
    READ a, n, d, w
    IF a = "Hello" AND n = 42 AND w = "World" THEN
        IF ABS(d - 3.14) < 0.0001 THEN
            PRINT "READ-PASS"
        ELSE
            PRINT "READ-FAIL d="; d
        END IF
    ELSE
        PRINT "READ-FAIL ["; a; "] "; n; " ["; w; "]"
    END IF

    RESTORE
    READ a
    IF a = "Hello" THEN
        PRINT "RESTORE-PASS"
    ELSE
        PRINT "RESTORE-FAIL ["; a; "]"
    END IF
END FUNCTION
