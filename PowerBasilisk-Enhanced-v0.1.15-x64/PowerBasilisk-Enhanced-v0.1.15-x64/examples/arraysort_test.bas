' ARRAY SORT verification (LONG + STRING arrays)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL i, ok AS LONG
    LOCAL arr() AS LONG
    LOCAL sarr() AS STRING
    REDIM arr(1 TO 6)
    arr(1) = 42: arr(2) = 7: arr(3) = 99: arr(4) = -3: arr(5) = 15: arr(6) = 0
    ARRAY SORT arr()
    ok = 1
    FOR i = 2 TO 6
        IF arr(i) < arr(i - 1) THEN ok = 0
    NEXT i
    IF arr(1) <> -3 OR arr(6) <> 99 THEN ok = 0
    REDIM sarr(1 TO 4)
    sarr(1) = "pear"
    sarr(2) = "apple"
    sarr(3) = "cherry"
    sarr(4) = "banana"
    ARRAY SORT sarr()
    IF sarr(1) <> "apple" OR sarr(4) <> "pear" THEN ok = 0
    IF ok = 1 THEN
        PRINT "SORT-PASS"
    ELSE
        PRINT "SORT-FAIL"
        FOR i = 1 TO 6: PRINT "arr("; i; ")="; arr(i): NEXT i
        FOR i = 1 TO 4: PRINT "sarr("; i; ")="; sarr(i): NEXT i
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
