' PowerBasilisk Enhanced - batch47_test.bas
' FONT NEW / FONT END (tier-3 -> implemented, batch 47)
FUNCTION PBMAIN() AS LONG
    LOCAL hfont AS LONG
    LOCAL h2 AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    ' FONT NEW "Arial", 12 TO hfont
    FONT NEW "Arial", 12 TO hfont
    IF hfont = 0 THEN
        PRINT "FAIL: font handle is zero"
        INCR fails
    ELSE
        PRINT "OK: font handle "; hfont
    END IF

    ' FONT NEW with style (bold+italic), points, charset
    FONT NEW "Courier New", 10, 3, 0, 0, 0 TO h2
    IF h2 = 0 THEN
        PRINT "FAIL: styled font handle is zero"
        INCR fails
    ELSE
        PRINT "OK: styled font handle "; h2
    END IF

    ' FONT END both
    FONT END hfont
    FONT END h2
    PRINT "OK: fonts ended"

    IF fails = 0 THEN
        PRINT "batch47: ALL PASS"
    ELSE
        PRINT "batch47: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
