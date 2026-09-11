' Batch 10: ARRAY SCAN
FUNCTION PBMAIN() AS LONG
    LOCAL a() AS LONG
    LOCAL i AS LONG
    LOCAL idx AS LONG
    LOCAL s() AS STRING

    REDIM a(1 TO 5)
    FOR i = 1 TO 5
        a(i) = i * 10
    NEXT i

    ARRAY SCAN a(), = 30, TO idx
    IF idx = 3 THEN
        PRINT "ARRAY-SCAN-EQ-PASS idx="; idx
    ELSE
        PRINT "ARRAY-SCAN-EQ-FAIL idx="; idx
    END IF

    ARRAY SCAN a(), > 40, TO idx
    IF idx = 5 THEN
        PRINT "ARRAY-SCAN-GT-PASS idx="; idx
    ELSE
        PRINT "ARRAY-SCAN-GT-FAIL idx="; idx
    END IF

    ARRAY SCAN a(), <> 10, TO idx
    IF idx = 2 THEN
        PRINT "ARRAY-SCAN-NEQ-PASS idx="; idx
    ELSE
        PRINT "ARRAY-SCAN-NEQ-FAIL idx="; idx
    END IF

    ARRAY SCAN a(), = 99, TO idx
    IF idx = 0 THEN
        PRINT "ARRAY-SCAN-NONE-PASS idx="; idx
    ELSE
        PRINT "ARRAY-SCAN-NONE-FAIL idx="; idx
    END IF

    REDIM s(1 TO 3)
    s(1) = "apple"
    s(2) = "banana"
    s(3) = "cherry"
    ARRAY SCAN s(), = "banana", TO idx
    IF idx = 2 THEN
        PRINT "ARRAY-SCAN-STR-PASS idx="; idx
    ELSE
        PRINT "ARRAY-SCAN-STR-FAIL idx="; idx
    END IF
END FUNCTION
