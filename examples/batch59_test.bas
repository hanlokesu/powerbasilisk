' PowerBasilisk Enhanced - batch59_test.bas
' GRAPHIC SET PIXEL / GET SIZE / SET+GET TEXTALIGN (batch 59)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL px AS LONG
    LOCAL w AS LONG
    LOCAL h AS LONG
    LOCAL ta AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp

    GRAPHIC SET PIXEL (20, 20), 16711680
    GRAPHIC GET PIXEL (20, 20) TO px
    PRINT "OK: pixel="; px
    IF px = 16711680 THEN
        PRINT "OK: set pixel red"
    ELSE
        PRINT "FAIL: pixel color wrong"
        INCR fails
    END IF

    GRAPHIC GET SIZE TO w, h
    PRINT "OK: size="; w; "x"; h
    IF w = 100 AND h = 50 THEN
        PRINT "OK: size matches bitmap"
    ELSE
        PRINT "FAIL: size wrong"
        INCR fails
    END IF

    GRAPHIC SET TEXTALIGN (2)
    GRAPHIC GET TEXTALIGN TO ta
    PRINT "OK: textalign="; ta
    IF ta = 2 THEN
        PRINT "OK: textalign round-trip"
    ELSE
        PRINT "FAIL: textalign wrong"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch59: ALL PASS"
    ELSE
        PRINT "batch59: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
