' PowerBasilisk Enhanced - batch57_test.bas
' GRAPHIC BITMAP LOAD / CHR SIZE / CELL / CELL SIZE (batch 57)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL hbmp2 AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL px AS LONG
    LOCAL cw AS LONG
    LOCAL ch AS LONG
    LOCAL csw AS LONG
    LOCAL csh AS LONG
    LOCAL cx AS LONG
    LOCAL cy AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp
    GRAPHIC BOX (10,10)-(40,40), 255, 255, 1
    GRAPHIC SAVE "batch57_out.bmp"
    GRAPHIC DETACH
    GRAPHIC BITMAP END

    GRAPHIC BITMAP LOAD "batch57_out.bmp" TO hbmp2
    IF hbmp2 <> 0 THEN
        PRINT "OK: bitmap loaded"
    ELSE
        PRINT "FAIL: bitmap load failed"
        INCR fails
    END IF

    GRAPHIC ATTACH hbmp2
    GRAPHIC GET PIXEL (25, 25) TO px
    PRINT "OK: loaded pixel="; px
    IF px <> 0 THEN
        PRINT "OK: loaded bitmap has content"
    ELSE
        PRINT "FAIL: loaded bitmap empty"
        INCR fails
    END IF

    GRAPHIC CHR SIZE ("ABC") TO cw, ch
    PRINT "OK: chr size="; cw; "x"; ch
    IF cw > 0 AND ch > 0 THEN
        PRINT "OK: chr size positive"
    ELSE
        PRINT "FAIL: chr size wrong"
        INCR fails
    END IF

    GRAPHIC CELL SIZE (2, 3) TO csw, csh
    PRINT "OK: cell size="; csw; "x"; csh
    IF csw > 0 AND csh > 0 THEN
        PRINT "OK: cell size positive"
    ELSE
        PRINT "FAIL: cell size wrong"
        INCR fails
    END IF

    GRAPHIC CELL (2, 3) TO cx, cy
    PRINT "OK: cell="; cx; ","; cy
    IF cx > 0 AND cy > 0 THEN
        PRINT "OK: cell positive"
    ELSE
        PRINT "FAIL: cell wrong"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END
    KILL "batch57_out.bmp"

    IF fails = 0 THEN
        PRINT "batch57: ALL PASS"
    ELSE
        PRINT "batch57: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
