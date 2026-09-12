' Control-flow verification: one-line IF, DO WHILE, DO..UNTIL, WHILE/WEND
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL t, i AS LONG
    ' one-line IF ... THEN ... ELSE
    t = 0
    IF 1 = 1 THEN t = 100 ELSE t = 200
    ' one-line IF without ELSE
    IF 2 > 1 THEN t = t + 10
    ' DO WHILE ... LOOP
    i = 0
    DO WHILE i < 5
        t = t + 1
        i = i + 1
    LOOP
    ' DO ... LOOP UNTIL
    i = 0
    DO
        t = t + 2
        i = i + 1
    LOOP UNTIL i >= 3
    ' WHILE ... WEND
    i = 0
    WHILE i < 4
        t = t + 3
        i = i + 1
    WEND
    PRINT "T="; t
    ' expect 100 + 10 + 5*1 + 3*2 + 4*3 = 133
    IF t = 133 THEN
        PRINT "CFLOW-PASS"
    ELSE
        PRINT "CFLOW-FAIL T="; t
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
