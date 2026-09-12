OPTION EXPLICIT

FUNCTION PBMAIN() AS LONG
    LOCAL a() AS LONG
    LOCAL sa() AS STRING
    LOCAL i AS LONG
    LOCAL ok AS LONG
    ok = 0

    ' --- enlarge: REDIM 1 TO 3 then 1 TO 5 ---
    REDIM a(1 TO 3)
    a(1) = 1: a(2) = 2: a(3) = 3
    REDIM a(1 TO 5)
    a(4) = 4: a(5) = 5
    FOR i = 1 TO 5
        PRINT "a("; i; ")="; a(i)
        IF a(i) <> i THEN ok = ok + 1
    NEXT i

    ' --- shrink: REDIM 1 TO 5 then 1 TO 2 ---
    REDIM a(1 TO 2)
    a(1) = 7: a(2) = 8
    IF a(1) <> 7 OR a(2) <> 8 THEN ok = ok + 10

    ' --- string array enlarged ---
    REDIM sa(1 TO 2)
    sa(1) = "a": sa(2) = "b"
    REDIM sa(1 TO 4)
    sa(3) = "c": sa(4) = "d"
    IF sa(1) <> "a" OR sa(4) <> "d" THEN ok = ok + 100

    ' --- REDIM inside IF block ---
    IF 1 = 1 THEN
        REDIM a(1 TO 6)
        a(6) = 99
    END IF
    IF a(6) <> 99 THEN ok = ok + 1000

    IF ok = 0 THEN
        PRINT "REDIM ALL PASS"
        FUNCTION = 0
    ELSE
        PRINT "REDIM FAIL code="; ok
        FUNCTION = 1
    END IF
END FUNCTION
