' batch61_test.bas — GRAPHIC GET PPI / GET+SET POS / TEXT SIZE / GET+SET STRETCHMODE / GET+SET CAPTION
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL x AS LONG, y AS LONG
    LOCAL px AS SINGLE, py AS SINGLE
    LOCAL tw AS SINGLE, th AS SINGLE
    LOCAL m AS LONG
    LOCAL cap AS STRING
    LOCAL ok AS LONG
    LOCAL waitk AS STRING
    ok = 0

    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    GRAPHIC ATTACH hbmp, 0

    ' 1. GET PPI
    GRAPHIC GET PPI TO x, y
    IF x > 0 AND y > 0 THEN ok = ok + 1 ELSE PRINT "PPI FAIL"; x; y

    ' 2. SET POS then GET POS
    GRAPHIC SET POS (30, 20)
    GRAPHIC GET POS TO px, py
    IF px = 30 AND py = 20 THEN ok = ok + 1 ELSE PRINT "POS FAIL"; px; py

    ' 3. TEXT SIZE
    GRAPHIC TEXT SIZE "Hello" TO tw, th
    IF tw > 0 AND th > 0 THEN ok = ok + 1 ELSE PRINT "TEXTSIZE FAIL"; tw; th

    ' 4. GET STRETCHMODE (Windows default BLACKONWHITE=1)
    GRAPHIC GET STRETCHMODE TO m
    IF m = 1 THEN ok = ok + 1 ELSE PRINT "STRETCHMODE GET FAIL"; m

    ' 5. SET STRETCHMODE 3 (COLORONCOLOR) then GET
    GRAPHIC SET STRETCHMODE 3
    GRAPHIC GET STRETCHMODE TO m
    IF m = 3 THEN ok = ok + 1 ELSE PRINT "STRETCHMODE SET FAIL"; m

    ' 6. SET CAPTION then GET CAPTION (console title bridge)
    GRAPHIC SET CAPTION "Batch61-Caption-Test"
    GRAPHIC GET CAPTION TO cap
    IF INSTR(cap, "Batch61-Caption-Test") > 0 THEN ok = ok + 1 ELSE PRINT "CAPTION FAIL"; cap

    GRAPHIC DETACH

    IF ok = 6 THEN
        PRINT "batch61: ALL PASS"
    ELSE
        PRINT "batch61: FAILURES="; 6 - ok
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
