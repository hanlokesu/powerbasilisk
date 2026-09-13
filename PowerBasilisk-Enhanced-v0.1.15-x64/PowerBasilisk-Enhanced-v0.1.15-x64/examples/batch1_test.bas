' Batch 1: TIX / MKBYT$ / ISINFINITE / ISNORMAL / CHDRIVE / PLAY WAVE / SETEOF
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL t AS QUAD
    LOCAL b AS STRING
    LOCAL f AS LONG
    LOCAL s AS STRING
    t = TIX
    IF t > 0 THEN PRINT "TIX-PASS "; t
    b = MKBYT$(65)
    IF b = "A" THEN PRINT "MKBYT-PASS"
    IF ISINFINITE(VAL("1E308") * 10) = -1 THEN PRINT "ISINF-PASS"
    IF ISNORMAL(123.456) = -1 THEN PRINT "ISNORM-PASS"
    CHDRIVE "C:"
    PRINT "CHDRIVE-PASS"
    PLAY WAVE "no_such_file.wav"
    PRINT "PLAYWAVE-PASS"
    f = FREEFILE
    OPEN "seteof_test.dat" FOR OUTPUT AS #f
    PRINT #f, "1234567890ABCDEFGHIJ"
    CLOSE #f
    f = FREEFILE
    OPEN "seteof_test.dat" FOR BINARY AS #f
    SEEK #f, 5
    SETEOF #f
    CLOSE #f
    OPEN "seteof_test.dat" FOR INPUT AS #f
    LINE INPUT #f, s
    CLOSE #f
    KILL "seteof_test.dat"
    IF LEN(s) > 0 AND LEN(s) < 20 THEN
        PRINT "SETEOF-PASS len="; LEN(s)
    ELSE
        PRINT "SETEOF-FAIL len="; LEN(s)
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
