' PowerBasilisk Enhanced - batch 60 test: GRAPHIC ARC / PIE / POLYLINE / PAINT
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL px AS LONG
    LOCAL ok AS LONG
    LOCAL waitk AS STRING
    ok = 0
    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp, 0

    ' 1. POLYLINE horizontal line
    GRAPHIC POLYLINE (10,10)-(90,10), &hFF0000
    GRAPHIC GET PIXEL (50, 10) TO px
    IF px = &hFF0000 THEN ok = ok + 1
    PRINT "polyline px="; px

    ' 2. ARC full ellipse outline
    GRAPHIC ARC (0,0)-(99,49), 0, 360, &h00FF00
    GRAPHIC GET PIXEL (50, 0) TO px
    IF px = &h00FF00 THEN ok = ok + 1
    PRINT "arc top px="; px

    ' 3. PIE full ellipse fill
    GRAPHIC PIE (0,0)-(99,49), 0, 360, &h0000FF, &h0000FF, 1
    GRAPHIC GET PIXEL (50, 25) TO px
    IF px = &h0000FF THEN ok = ok + 1
    PRINT "pie center px="; px

    ' 4. PAINT flood fill inside a box
    GRAPHIC BOX (20,20)-(80,40), &hFFFFFF
    GRAPHIC PAINT (50, 30), &h00FF00, &hFFFFFF
    GRAPHIC GET PIXEL (50, 30) TO px
    IF px = &h00FF00 THEN ok = ok + 1
    PRINT "paint center px="; px

    GRAPHIC DETACH
    IF ok = 4 THEN
        PRINT "batch60: ALL PASS"
    ELSE
        PRINT "batch60: FAILURES="; 4 - ok
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
