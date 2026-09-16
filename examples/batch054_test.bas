' PowerBasilisk Enhanced - batch54_test.bas
' GRAPHIC WIDTH / STYLE / SAVE (batch 54)
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
    GRAPHIC WIDTH 3
    PRINT "OK: width set"

    GRAPHIC STYLE 0
    PRINT "OK: style set"

    GRAPHIC LINE (10,10)-(90,40), 255
    PRINT "OK: line drawn"

    GRAPHIC SAVE "batch54_out.bmp"
    PRINT "OK: saved"

    IF ISFILE("batch54_out.bmp") THEN
        PRINT "OK: file exists"
    ELSE
        PRINT "FAIL: bmp file missing"
        INCR fails
    END IF

    KILL "batch54_out.bmp"
    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch54: ALL PASS"
    ELSE
        PRINT "batch54: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
