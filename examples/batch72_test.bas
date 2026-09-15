' PowerBasilisk Enhanced - Batch 72 Test: XPRINT CLIP/SCALE/LINES/CELL SIZE/CHR SIZE/COPY
FUNCTION PBMAIN() AS LONG
    LOCAL cx1 AS LONG, cy1 AS LONG, cx2 AS LONG, cy2 AS LONG
    LOCAL sw AS LONG, sh AS LONG
    LOCAL lines AS LONG
    LOCAL cw AS LONG, ch AS LONG
    LOCAL chrw AS LONG, chrh AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 72: XPRINT clip + scale + metrics ==="

    XPRINT ATTACH DEFAULT

    XPRINT SET CLIP 10, 10, 500, 500
    XPRINT GET CLIP TO cx1, cy1, cx2, cy2
    PRINT "GET CLIP:"; cx1; cy1; cx2; cy2
    IF cx2 <= cx1 OR cy2 <= cy1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SCALE 1000, 1000
    XPRINT GET SCALE TO sw, sh
    PRINT "GET SCALE:"; sw; sh
    IF sw <> 1000 OR sh <> 1000 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT GET LINES TO lines
    PRINT "GET LINES:"; lines
    IF lines = 0 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT CELL SIZE TO cw, ch
    PRINT "CELL SIZE:"; cw; "x"; ch
    IF cw = 0 OR ch = 0 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT CHR SIZE TO chrw, chrh
    PRINT "CHR SIZE:"; chrw; "x"; chrh
    IF chrw <> cw OR chrh <> ch THEN fails = fails + 1 : PRINT "  FAIL: chr != cell"

    XPRINT COPY 0, 0, 100, 100, 0, 0
    PRINT "COPY: done"

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
