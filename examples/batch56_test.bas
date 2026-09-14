' PowerBasilisk Enhanced - batch56_test.bas
' GRAPHIC CIRCLE / POLYGON / GET CLIENT / GET LOC (batch 56)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL px AS LONG
    LOCAL cw AS LONG
    LOCAL ch AS LONG
    LOCAL lx AS LONG
    LOCAL ly AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    IF hbmp = 0 THEN
        PRINT "FAIL: bitmap handle is zero"
        INCR fails
    ELSE
        PRINT "OK: bitmap handle "; hbmp
    END IF

    GRAPHIC ATTACH hbmp

    GRAPHIC CIRCLE (50, 25), 15, 255
    PRINT "OK: circle drawn"

    GRAPHIC GET PIXEL (50, 25) TO px
    PRINT "OK: center pixel="; px
    IF px <> 0 THEN
        PRINT "OK: circle center non-zero"
    ELSE
        PRINT "FAIL: circle center is zero"
        INCR fails
    END IF

    GRAPHIC POLYGON (10,10)-(30,10)-(20,30), 255
    PRINT "OK: polygon drawn"

    GRAPHIC GET PIXEL (20, 20) TO px
    PRINT "OK: polygon pixel="; px
    IF px <> 0 THEN
        PRINT "OK: polygon interior non-zero"
    ELSE
        PRINT "FAIL: polygon interior is zero"
        INCR fails
    END IF

    GRAPHIC GET CLIENT TO cw, ch
    PRINT "OK: client="; cw; "x"; ch
    IF cw = 100 AND ch = 50 THEN
        PRINT "OK: client size correct"
    ELSE
        PRINT "FAIL: client size wrong"
        INCR fails
    END IF

    GRAPHIC GET LOC TO lx, ly
    PRINT "OK: loc="; lx; ","; ly
    IF lx = 0 AND ly = 0 THEN
        PRINT "OK: loc correct"
    ELSE
        PRINT "FAIL: loc wrong"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch56: ALL PASS"
    ELSE
        PRINT "batch56: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
