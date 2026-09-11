' Batch 8: ARRAY DELETE
FUNCTION PBMAIN() AS LONG
    LOCAL a() AS LONG
    LOCAL i AS LONG
    LOCAL ok AS LONG

    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i

    ARRAY DELETE a(2)
    ' now 10,30,40,50 (tail zeroed)
    IF a(1) = 10 AND a(2) = 30 AND a(3) = 40 AND a(4) = 50 THEN
        PRINT "ARRAY-DELETE-PASS"
    ELSE
        PRINT "ARRAY-DELETE-FAIL a(1)="; a(1); " a(2)="; a(2); " a(3)="; a(3); " a(4)="; a(4)
    END IF

    ARRAY DELETE a(1) FOR 2
    ' now 40,50
    IF a(1) = 40 AND a(2) = 50 THEN
        PRINT "ARRAY-DELETE-FOR-PASS"
    ELSE
        PRINT "ARRAY-DELETE-FOR-FAIL a(1)="; a(1); " a(2)="; a(2)
    END IF
END FUNCTION
