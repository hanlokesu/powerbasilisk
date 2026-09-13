' Batch 7: LOF / LOC / SEEK functions
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL len1 AS QUAD
    LOCAL pos1 AS QUAD

    f = FREEFILE
    OPEN "lof_test.tmp" FOR OUTPUT AS #f
    WRITE #f, "Hello World"
    CLOSE #f

    OPEN "lof_test.tmp" FOR INPUT AS #f
    len1 = LOF(f)
    IF len1 >= 11 THEN
        PRINT "LOF-PASS len="; len1
    ELSE
        PRINT "LOF-FAIL len="; len1
    END IF

    pos1 = LOC(f)
    IF pos1 = 1 THEN
        PRINT "LOC-PASS pos="; pos1
    ELSE
        PRINT "LOC-FAIL pos="; pos1
    END IF

    SEEK #f, 2
    pos1 = LOC(f)
    IF pos1 = 2 THEN
        PRINT "SEEK-FUNC-PASS pos="; pos1
    ELSE
        PRINT "SEEK-FUNC-FAIL pos="; pos1
    END IF
    CLOSE #f
    KILL "lof_test.tmp"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
