' Batch 3: PLAY SOUND / SPLIT / ARRAY SHUFFLE
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL a AS STRING
    LOCAL b AS STRING
    LOCAL i AS LONG
    LOCAL sum AS LONG
    LOCAL arr() AS LONG

    PLAY SOUND 440, 60
    PRINT "PLAYSOUND-PASS"

    s = "ABCDEF"
    SPLIT s, 2 TO a, b
    IF a = "AB" AND b = "CDEF" THEN
        PRINT "SPLIT-PASS"
    ELSE
        PRINT "SPLIT-FAIL ["; a; "] ["; b; "]"
    END IF

    REDIM arr(1 TO 5)
    FOR i = 1 TO 5
        arr(i) = i
    NEXT i
    ARRAY SHUFFLE arr()
    sum = 0
    FOR i = 1 TO 5
        sum = sum + arr(i)
    NEXT i
    IF sum = 15 THEN
        PRINT "SHUFFLE-PASS"
    ELSE
        PRINT "SHUFFLE-FAIL sum="; sum
    END IF
END FUNCTION
