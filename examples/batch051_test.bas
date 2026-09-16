' PowerBasilisk Enhanced - batch51_test.bas
' GRAPHIC BITMAP NEW / GRAPHIC BITMAP END (batch 51)
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

    GRAPHIC BITMAP END
    PRINT "OK: bitmap ended"

    IF fails = 0 THEN
        PRINT "batch51: ALL PASS"
    ELSE
        PRINT "batch51: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
