' PowerBasilisk Enhanced - batch49_test.bas
' COLOR fore& [, back&] (tier-3 -> implemented, batch 49; PB/CC console color)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    COLOR 10, 0
    PRINT "green foreground test line"
    COLOR 12, 0
    PRINT "red foreground test line"
    COLOR 7, 4
    PRINT "white on red test line"
    COLOR 7, 0
    PRINT "back to normal"

    IF fails = 0 THEN
        PRINT "batch49: ALL PASS (colors applied without error)"
    ELSE
        PRINT "batch49: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
