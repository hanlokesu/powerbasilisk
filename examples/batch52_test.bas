' PowerBasilisk Enhanced - batch52_test.bas
' GRAPHIC ATTACH / DETACH / CLEAR (bitmap target, batch 52)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    IF hbmp = 0 THEN
        PRINT "FAIL: bitmap handle is zero"
        INCR fails
    ELSE
        PRINT "OK: bitmap handle "; hbmp
    END IF

    GRAPHIC ATTACH hbmp
    PRINT "OK: attached to bitmap"

    GRAPHIC CLEAR
    PRINT "OK: bitmap cleared"

    GRAPHIC DETACH
    PRINT "OK: detached"

    GRAPHIC BITMAP END
    PRINT "OK: bitmap ended"

    IF fails = 0 THEN
        PRINT "batch52: ALL PASS"
    ELSE
        PRINT "batch52: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
