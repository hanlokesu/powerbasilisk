' PowerBasilisk Enhanced - batch58_test.bas
' GRAPHIC GET CANVAS / GET DC / GET MIX / SET MIX (batch 58)
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL hc AS QUAD
    LOCAL hdc AS QUAD
    LOCAL mix AS LONG

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp

    GRAPHIC GET CANVAS TO hc
    PRINT "OK: canvas="; hc
    IF hc = hbmp THEN
        PRINT "OK: canvas matches bitmap"
    ELSE
        PRINT "FAIL: canvas mismatch"
        INCR fails
    END IF

    GRAPHIC GET DC TO hdc
    PRINT "OK: dc="; hdc
    IF hdc <> 0 THEN
        PRINT "OK: dc non-zero"
    ELSE
        PRINT "FAIL: dc zero"
        INCR fails
    END IF

    GRAPHIC SET MIX (7)
    GRAPHIC GET MIX TO mix
    PRINT "OK: mix="; mix
    IF mix = 7 THEN
        PRINT "OK: mix set/get round-trip"
    ELSE
        PRINT "FAIL: mix wrong"
        INCR fails
    END IF

    GRAPHIC SET MIX (13)
    GRAPHIC GET MIX TO mix
    IF mix = 13 THEN
        PRINT "OK: mix reset"
    ELSE
        PRINT "FAIL: mix reset wrong"
        INCR fails
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END

    IF fails = 0 THEN
        PRINT "batch58: ALL PASS"
    ELSE
        PRINT "batch58: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
