' ARRAY SORT verification (LONG array)
FUNCTION PBMAIN() AS LONG
    LOCAL i, ok AS LONG
    LOCAL arr() AS LONG
    REDIM arr(1 TO 6)
    arr(1) = 42: arr(2) = 7: arr(3) = 99: arr(4) = -3: arr(5) = 15: arr(6) = 0
    ARRAY SORT arr()
    ok = 1
    FOR i = 2 TO 6
        IF arr(i) < arr(i - 1) THEN ok = 0
    NEXT i
    IF arr(1) <> -3 OR arr(6) <> 99 THEN ok = 0
    IF ok = 1 THEN
        PRINT "SORT-PASS"
    ELSE
        PRINT "SORT-FAIL"
        FOR i = 1 TO 6: PRINT "arr("; i; ")="; arr(i): NEXT i
    END IF
END FUNCTION
