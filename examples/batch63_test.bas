' PowerBasilisk Enhanced - Batch 63 test
' GRAPHIC GET CLIP / GET VIEW / SET VIEW / GET LINES / GET+SET WRAP
' All statements verified against a memory DIB bitmap (console-testable).
FUNCTION PBMAIN() AS LONG
    LOCAL hBmp AS QUAD
    LOCAL cw AS SINGLE
    LOCAL ch AS SINGLE
    LOCAL vx AS SINGLE
    LOCAL vy AS SINGLE
    LOCAL lines AS LONG
    LOCAL wrapv AS LONG
    LOCAL fails AS LONG
    LOCAL waitk AS STRING

    fails = 0

    ' Create a 100 x 50 memory bitmap and attach it
    GRAPHIC BITMAP NEW 100, 50 TO hBmp
    GRAPHIC ATTACH hBmp

    ' 1. GRAPHIC GET CLIP TO w!, h!  - default clip area is the whole bitmap
    GRAPHIC GET CLIP TO cw, ch
    IF cw <> 100 OR ch <> 50 THEN
        PRINT "FAIL 1: GET CLIP = "; cw; "x"; ch; " (expected 100x50)"
        fails = fails + 1
    ELSE
        PRINT "OK 1: GET CLIP = 100x50"
    END IF

    ' 2. GRAPHIC GET VIEW default -> 0, 0
    GRAPHIC GET VIEW TO vx, vy
    IF vx <> 0 OR vy <> 0 THEN
        PRINT "FAIL 2: GET VIEW default = "; vx; ","; vy; " (expected 0,0)"
        fails = fails + 1
    ELSE
        PRINT "OK 2: GET VIEW default = 0,0"
    END IF

    ' 3. GRAPHIC SET VIEW 20, 30 then GET VIEW -> 20, 30
    GRAPHIC SET VIEW 20, 30
    GRAPHIC GET VIEW TO vx, vy
    IF vx <> 20 OR vy <> 30 THEN
        PRINT "FAIL 3: GET VIEW after SET VIEW = "; vx; ","; vy; " (expected 20,30)"
        fails = fails + 1
    ELSE
        PRINT "OK 3: SET VIEW 20,30 -> GET VIEW = 20,30"
    END IF

    ' 4. GRAPHIC GET LINES TO n& - bitmap height = 50 lines
    GRAPHIC GET LINES TO lines
    IF lines <> 50 THEN
        PRINT "FAIL 4: GET LINES = "; lines; " (expected 50)"
        fails = fails + 1
    ELSE
        PRINT "OK 4: GET LINES = 50"
    END IF

    ' 5. GRAPHIC SET WRAP 0 then GET WRAP -> 0
    GRAPHIC SET WRAP 0
    GRAPHIC GET WRAP TO wrapv
    IF wrapv <> 0 THEN
        PRINT "FAIL 5: GET WRAP after SET WRAP 0 = "; wrap
        fails = fails + 1
    ELSE
        PRINT "OK 5: SET WRAP 0 -> GET WRAP = 0"
    END IF

    ' 6. GRAPHIC SET WRAP 1 then GET WRAP -> 1
    GRAPHIC SET WRAP 1
    GRAPHIC GET WRAP TO wrapv
    IF wrapv <> 1 THEN
        PRINT "FAIL 6: GET WRAP after SET WRAP 1 = "; wrap
        fails = fails + 1
    ELSE
        PRINT "OK 6: SET WRAP 1 -> GET WRAP = 1"
    END IF

    GRAPHIC DETACH
    GRAPHIC BITMAP END hBmp

    IF fails = 0 THEN
        PRINT "ALL PASS (6/6)"
    ELSE
        PRINT "TOTAL FAILS: "; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
