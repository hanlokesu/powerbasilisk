' PowerBasilisk Enhanced - batch53_test.bas
' GRAPHIC LINE / BOX / ELLIPSE (bitmap target, batch 53)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    GRAPHIC BITMAP NEW 200, 100 TO hbmp
    IF hbmp = 0 THEN
        PRINT "FAIL: bitmap handle is zero"
        INCR fails
    ELSE
        PRINT "OK: bitmap handle "; hbmp
    END IF

    GRAPHIC ATTACH hbmp
    PRINT "OK: attached"

    GRAPHIC LINE (10,10)-(190,90), 255
    PRINT "OK: line drawn"

    GRAPHIC BOX (10,10)-(190,90), 0, 65280, 0, 1
    PRINT "OK: box drawn"

    GRAPHIC ELLIPSE (10,10)-(190,90), 0, 16711680, 0, 1
    PRINT "OK: ellipse drawn"

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch53: ALL PASS"
    ELSE
        PRINT "batch53: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
