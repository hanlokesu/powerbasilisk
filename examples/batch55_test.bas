' PowerBasilisk Enhanced - batch55_test.bas
' GRAPHIC COLOR / GET PIXEL / COPY (batch 55)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL px AS LONG
    LOCAL px2 AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    IF hbmp = 0 THEN
        PRINT "FAIL: bitmap handle is zero"
        INCR fails
    ELSE
        PRINT "OK: bitmap handle "; hbmp
    END IF

    GRAPHIC ATTACH hbmp
    GRAPHIC COLOR 255, 0
    PRINT "OK: color set"

    GRAPHIC BOX (10,10)-(40,40), 255, 255, 1
    PRINT "OK: solid box drawn"

    GRAPHIC GET PIXEL (25, 25) TO px
    PRINT "OK: pixel="; px
    IF px <> 0 THEN
        PRINT "OK: pixel non-zero (fill color)"
    ELSE
        PRINT "FAIL: pixel is zero"
        INCR fails
    END IF

    GRAPHIC COPY (10,10)-(40,40), (0,0)
    PRINT "OK: copied"

    GRAPHIC GET PIXEL (25, 25) TO px2
    PRINT "OK: pixel2="; px2
    IF px2 <> 0 THEN
        PRINT "OK: copy region non-zero"
    ELSE
        PRINT "FAIL: copy region is zero"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch55: ALL PASS"
    ELSE
        PRINT "batch55: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
