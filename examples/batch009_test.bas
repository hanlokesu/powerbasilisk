' Batch 9: ARRAY INSERT
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a() AS LONG
    LOCAL i AS LONG

    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i

    ARRAY INSERT a(2), 25
    ' fixed array: insert at 2 -> 10,25,20,30,40 (last element shifted out)
    IF a(1) = 10 AND a(2) = 25 AND a(3) = 20 AND a(4) = 30 AND a(5) = 40 THEN
        PRINT "ARRAY-INSERT-PASS"
    ELSE
        PRINT "ARRAY-INSERT-FAIL a(1)="; a(1); " a(2)="; a(2); " a(3)="; a(3); " a(4)="; a(4); " a(5)="; a(5)
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
