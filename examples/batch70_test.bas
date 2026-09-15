' PowerBasilisk Enhanced - Batch 70 Test: XPRINT ARC/ELLIPSE/PIE/FONT/MIX/STRETCHMODE
FUNCTION PBMAIN() AS LONG
    LOCAL attached AS LONG
    LOCAL mix AS LONG
    LOCAL sm AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 70: XPRINT shapes + font + mix ==="

    XPRINT ATTACH DEFAULT
    XPRINT GET ATTACH TO attached
    IF attached <> 1 THEN fails = fails + 1 : PRINT "FAIL: attach"

    XPRINT SET COLOR 255
    XPRINT ARC 10, 10, 200, 200, 10, 10, 200, 200
    PRINT "ARC: done"

    XPRINT ELLIPSE 50, 50, 250, 200
    PRINT "ELLIPSE: done"

    XPRINT PIE 10, 10, 300, 300, 10, 10, 300, 10
    PRINT "PIE: done"

    XPRINT SET FONT "Arial", 24, 1, 0
    XPRINT SET POS 50, 350
    XPRINT PRINT "Bold 24pt Arial"
    PRINT "SET FONT: done"

    XPRINT SET MIX 11
    XPRINT GET MIX TO mix
    PRINT "SET/GET MIX:"; mix
    IF mix <> 11 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET STRETCHMODE 3
    XPRINT GET STRETCHMODE TO sm
    PRINT "SET/GET STRETCHMODE:"; sm
    IF sm <> 3 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT CLOSE

    PRINT "=== Result: ";
    IF fails = 0 THEN
        PRINT "ALL PASS"
    ELSE
        PRINT fails; " FAILED"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
