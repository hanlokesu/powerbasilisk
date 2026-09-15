' PowerBasilisk Enhanced - Batch 71 Test: XPRINT TEXT SIZE / GET CLIENT / GET CANVAS / WRAP / WORDWRAP / OVERLAP
FUNCTION PBMAIN() AS LONG
    LOCAL tw AS LONG, th AS LONG
    LOCAL cw AS LONG, ch AS LONG
    LOCAL cw2 AS LONG, ch2 AS LONG
    LOCAL wrap AS LONG, ww AS LONG, ov AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 71: XPRINT text size + client + wrap ==="

    XPRINT ATTACH DEFAULT

    XPRINT TEXT SIZE "Hello World" TO tw, th
    PRINT "TEXT SIZE:"; tw; "x"; th
    IF tw = 0 OR th = 0 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT GET CLIENT TO cw, ch
    PRINT "GET CLIENT:"; cw; "x"; ch
    IF cw = 0 OR ch = 0 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT GET CANVAS TO cw2, ch2
    PRINT "GET CANVAS:"; cw2; "x"; ch2
    IF cw2 <> cw OR ch2 <> ch THEN fails = fails + 1 : PRINT "  FAIL: canvas != client"

    XPRINT SET WRAP 1
    XPRINT GET WRAP TO wrap
    PRINT "SET/GET WRAP:"; wrap
    IF wrap <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET WORDWRAP 1
    XPRINT GET WORDWRAP TO ww
    PRINT "SET/GET WORDWRAP:"; ww
    IF ww <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET OVERLAP 50
    XPRINT GET OVERLAP TO ov
    PRINT "SET/GET OVERLAP:"; ov
    IF ov <> 50 THEN fails = fails + 1 : PRINT "  FAIL"

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
