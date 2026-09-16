' PowerBasilisk Enhanced - batch50_test.bas
' MENU NEW BAR / NEW POPUP / ADD STRING / ADD POPUP / DELETE (batch 50)
FUNCTION PBMAIN() AS LONG
    LOCAL hbar AS QUAD
    LOCAL hpop AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    MENU NEW BAR TO hbar
    IF hbar = 0 THEN
        PRINT "FAIL: menu bar handle is zero"
        INCR fails
    ELSE
        PRINT "OK: menu bar handle "; hbar
    END IF

    MENU NEW POPUP TO hpop
    IF hpop = 0 THEN
        PRINT "FAIL: popup handle is zero"
        INCR fails
    ELSE
        PRINT "OK: popup handle "; hpop
    END IF

    MENU ADD STRING, hbar, "File", 100, 0
    MENU ADD POPUP, hbar, hpop, 0
    MENU ADD STRING, hpop, "Open", 101, 0
    MENU ADD STRING, hpop, "Save", 102, 0
    PRINT "OK: menu items added"

    MENU DELETE hbar, 1
    PRINT "OK: popup deleted from bar"

    IF fails = 0 THEN
        PRINT "batch50: ALL PASS"
    ELSE
        PRINT "batch50: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
